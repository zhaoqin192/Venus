//
//  GMMeTakeAwayViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayViewController.h"
#import "XFSegementView.h"
#import "GMMeTakeAwayCell.h"
#import "NetworkFetcher+FoodOrder.h"
#import "FoodOrderManager.h"
#import "TakeAwayOrder.h"
#import "PresentationUtility.h"
#import "GMMeTakeAwayDetailViewController.h"
#import "MBProgressHUD.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Expand.h"
#import "GMMeTakeAwayRefundViewController.h"
#import "GMMeTakeAwayRatingViewController.h"
#import "FoodViewController.h"
#import "FoodSubmitOrderViewController.h"
#import "FoodOrderViewBaseItem.h"
#import "MJRefresh.h"

@interface GMMeTakeAwayViewController () <UITableViewDelegate, UITableViewDataSource, TouchLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *placeHolderView;
@property (strong, nonatomic) XFSegementView *segementView;
@property (assign, nonatomic) NSInteger currentSemementIndex;

@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FoodOrderManager *orderManager;

@property (strong, nonatomic) MJRefreshNormalHeader *head;
@property (strong, nonatomic) MJRefreshBackNormalFooter *foot;
@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation GMMeTakeAwayViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.navigationItem.rightBarButtonItem = self.searchButton;
    [self.placeHolderView addSubview:[self segementView]];
    self.tableView.mj_header = self.head;
    self.tableView.mj_footer = self.foot;

}

- (void)viewWillAppear:(BOOL)animated {
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.orderManager updateOrderSucceed:^{
        [self.hud hide:YES];
        [self.tableView reloadData];
    } failed:^(NSString *error) {
        [self.hud hide:YES];
        NSLog(@"网络错误，错误是%@",error);
    }];
    
    self.navigationItem.title = @"订单";
    [MobClick beginLogPageView:@"GMMeTakeAwayViewController"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"GMMeTakeAwayViewController"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderManager.orderArray.count != 0) {
        if (self.currentSemementIndex == 0) {
            return self.orderManager.orderArray.count;
        } else if (self.currentSemementIndex == 1) {
            if (self.orderManager.waitingEvalutationOrderArray) {
                return self.orderManager.waitingEvalutationOrderArray.count;
            } else {
                return 0;
            }
        } else {
            if (self.orderManager.refundOrderArray) {
                return self.orderManager.refundOrderArray.count;
            } else {
                return 0;
            }
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMMeTakeAwayCell *cell = [GMMeTakeAwayCell cellForTableView:tableView];
    [cell.leftOneMoreOrderButton addTarget:self action:@selector(oneMoreOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightOneMoreOrderButton addTarget:self action:@selector(oneMoreOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.evaluateButton addTarget:self action:@selector(evaluateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reorderButton addTarget:self action:@selector(reorderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.changeStoreButton addTarget:self action:@selector(changeStoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refundButton addTarget:self action:@selector(refundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelOrderButton addTarget:self action:@selector(cancelOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightCancelorderButton addTarget:self action:@selector(cancelOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if  (self.currentSemementIndex == 0) {
        if (self.orderManager.orderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.orderArray[indexPath.row];
        }
    } else if (self.currentSemementIndex == 1){
        if (self.orderManager.waitingEvalutationOrderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.waitingEvalutationOrderArray[indexPath.row];
        }
    } else {
        if (self.orderManager.refundOrderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.refundOrderArray[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GMMeTakeAwayDetailViewController *vc = [[GMMeTakeAwayDetailViewController alloc] init];
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    vc.orderID = cell.order.orderId;
    vc.orderState = cell.order.state;
    vc.refundState = cell.order.refundState;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TouchLabelDelegate
- (void)touchLabelWithIndex:(NSInteger)index {
    self.currentSemementIndex = index;
    [self.tableView reloadData];
}

#pragma mark - private methods
- (void)prepayWithOrderID:(long)orderID {
    [NetworkFetcher foodAlipayWithOrderID:orderID success:^(NSDictionary *response){
        // 调起支付宝
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            NSDictionary *data = response[@"data"];
            NSString *privateKey = data[@"sign"];
            
            //生成订单信息及签名
            Order *order = [[Order alloc] init];
            order.partner = data[@"partner"];
            order.sellerID = data[@"seller_id"];
            order.outTradeNO = data[@"out_trade_no"];
            order.service = data[@"service"];
            order.inputCharset = data[@"_input_charset"];
            order.notifyURL = data[@"notify_url"];
            order.subject = data[@"subject"];
            order.paymentType = data[@"payment_type"];
            order.body = data[@"body"];
            order.totalFee = data[@"total_fee"];
            
            NSString *appScheme = @"alipay2088411898385492";
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            
            
            NSString *urlencoding = [NSString urlEncodedString:privateKey];
            
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, urlencoding, @"RSA"];
            
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                [self.orderManager updateOrderSucceed:^{
                    [self.tableView reloadData];
                } failed:^(NSString *error) {
                    [self.tableView reloadData];
                }];
            }];
        } else {
            NSLog(@"下单失败");
        }
    } failure:^(NSString *error){
        NSLog(@"网络请求异常");
    }];
}

- (void)headRefresh:(id)sender {
    NSLog(@"下拉刷新");
    __weak typeof(self) weakSelf = self;
    self.currentPage = 0;
    [self.orderManager updateOrderSucceed:^{
        [weakSelf.head endRefreshing];
        [weakSelf.tableView reloadData];
    } failed:^(NSString *error) {
        [self.head endRefreshing];
    }];
}

- (void)footRefresh:(id)sender {
    NSLog(@"上拉刷新");
    __weak typeof(self) weakSelf = self;
    self.currentPage += 1;
    [self.orderManager addDataOnPage:self.currentPage succeed:^ {
        [weakSelf.foot endRefreshing];
        [weakSelf.tableView reloadData];
    } failed:^(NSString *error) {
        NSLog(@"没有更多数据");
        [weakSelf.foot endRefreshingWithNoMoreData];
    }];
}

#pragma mark - event response
- (void)searchButtonClicked:(id)sender {
    NSLog(@"搜索按钮点击");
}

- (void)oneMoreOrderButtonClicked:(id)sender {
    NSLog(@"再来一单按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
    vc.restaurantName = cell.order.store.name;
    vc.restaurantID = [NSString stringWithFormat:@"%li",cell.order.store.storeId];
    vc.shippingFee = cell.order.packFee;
    vc.bargainFee = 0;
    vc.totalPrice = cell.order.totalFee / 100.0;
    vc.costTime = 50;
    for (int i = 0; i < cell.order.goodsDetail.count; i++) {
        FoodOrderViewBaseItem *item = [[FoodOrderViewBaseItem alloc] initWithTakeAwayOrderGood:cell.order.goodsDetail[i]];
        [vc.foodArray addObject:item];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)evaluateButtonClicked:(id)sender {
    NSLog(@"评价按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    GMMeTakeAwayRatingViewController *vc = [[GMMeTakeAwayRatingViewController alloc] init];
    vc.name = cell.order.store.name;
    vc.storeIconURL = cell.order.store.icon;
    vc.storeID = cell.order.store.storeId;
    vc.orderID = cell.order.orderId;
    vc.deliveryTime = 123;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)reorderButtonClicked:(id)sender {
    NSLog(@"重新下单按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
    vc.restaurantName = cell.order.store.name;
    vc.restaurantID = [NSString stringWithFormat:@"%li",cell.order.store.storeId];
    vc.shippingFee = cell.order.packFee;
    vc.bargainFee = 0;
    vc.totalPrice = cell.order.totalFee / 100.0;
    vc.costTime = 50;
    [vc.foodArray removeAllObjects];
    for (int i = 0; i < cell.order.goodsDetail.count; i++) {
        FoodOrderViewBaseItem *item = [[FoodOrderViewBaseItem alloc] initWithTakeAwayOrderGood:cell.order.goodsDetail[i]];
        [vc.foodArray addObject:item];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)changeStoreButtonClicked:(id)sender {
    NSLog(@"换个店铺按钮点击");
    FoodViewController *vc = [[FoodViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payButtonClicked:(id)sender {
    NSLog(@"付款按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    [self prepayWithOrderID:(long)cell.order.orderId];
}

- (void)refundButtonClicked:(id)sender {
    NSLog(@"退款按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    GMMeTakeAwayRefundViewController *vc = [[GMMeTakeAwayRefundViewController alloc] init];
    vc.orderID = cell.order.orderId;
    vc.totalPrice = cell.order.totalFee / 100.0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelOrderButtonClicked:(id)sender {
    NSLog(@"取消订单按钮点击!!!!");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"订单号码是%li",(long)cell.order.orderId);
    [NetworkFetcher foodCancelOrderWithOrderID:(long)cell.order.orderId success:^(NSDictionary *response){
        hud.hidden = YES;
        [PresentationUtility showTextDialog:self.view text:@"取消订单成功" success:^{
            [self.orderManager updateOrderSucceed:^{
                [self.tableView reloadData];
            } failed:^(NSString *error) {
                [self.tableView reloadData];
            }];
        }];
        
    } failure:^(NSString *error){
        hud.hidden = YES;
        [PresentationUtility showTextDialog:self.view text:@"取消订单失败" success:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)confirmButtonClicked:(id)sender {
    NSLog(@"确认按钮点击");
    GMMeTakeAwayCell *cell = (GMMeTakeAwayCell *)[[(UIButton *)sender superview] superview];
    [NetworkFetcher foodConfirmOrderWithOrderID:(long)cell.order.orderId storeID:(long)cell.order.orderId success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [PresentationUtility showTextDialog:self.view text:@"确认收货成功" success:^{
                [self.orderManager updateOrderSucceed:^{
                    [self.tableView reloadData];
                } failed:^(NSString *error) {
                    [self.tableView reloadData];
                }];
            }];
        }
    } failure:^(NSString *error) {
        [PresentationUtility showTextDialog:self.view text:@"确认收货失败" success:^{
            [self.tableView reloadData];
        }];
    }];
}

#pragma mark - getters and setters
- (XFSegementView *)segementView {
    if (!_segementView) {
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _segementView.titleArray = @[@"全部",@"待评价",@"退款"];
        _segementView.backgroundColor = [UIColor whiteColor];
        _segementView.titleColor = [UIColor lightGrayColor];
        _segementView.haveRightLine = YES;
        _segementView.separateColor = [UIColor grayColor];
        [_segementView.scrollLine setBackgroundColor:GMBrownColor];
        _segementView.titleSelectedColor = GMBrownColor;
        _segementView.touchDelegate = self;
        [_segementView selectLabelWithIndex:0];
    }
    return _segementView;
}

- (UIBarButtonItem *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked:)];
    }
    return _searchButton;
}

- (FoodOrderManager *)orderManager {
    if (!_orderManager) {
        _orderManager = [FoodOrderManager sharedInstance];
    }
    return _orderManager;
}

- (MJRefreshNormalHeader *)head {
    if (!_head) {
        _head = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh:)];
        _head.lastUpdatedTimeLabel.hidden = YES;
        _head.arrowView.hidden = YES;
        _head.stateLabel.hidden = YES;
    }
    return _head;
}

- (MJRefreshBackNormalFooter *)foot {
    if (!_foot) {
        _foot = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh:)];
        _foot.automaticallyHidden = YES;
    }
    return _foot;
}

@end
