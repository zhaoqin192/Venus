//
//  GMMeTakeAwayDetailViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayDetailViewController.h"
#import "NetworkFetcher+FoodOrder.h"
#import "TakeAwayOrderDetail.h"
#import "FoodBillCell.h"
#import "TakeAwayOrderGood.h"
#import "FoodShippingFeeCell.h"
#import "GMMeTakeAwayDetailTotalFeeCell.h"
#import "GMMeTakeAwayDetailButtonCell.h"
#import "GMMeTakeAwayDetailInfoCell.h"
#import "NSString+Expand.h"
#import "PureLayout.h"
#import "GMMeTakeAwayRefundViewController.h"
#import "FoodViewController.h"
#import "Order.h"
#import "GMMeTakeAwayRatingViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FoodSubmitOrderViewController.h"
#import "FoodOrderViewBaseItem.h"
#import "MBProgressHUD.h"

@interface GMMeTakeAwayDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TakeAwayOrderDetail *orderDetail;

#pragma mark - redButton
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeStore;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation GMMeTakeAwayDetailViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self hideRedButton];
    self.navigationItem.title = @"订单详情";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkFetcher foodFetcherUserFoodOrderDetailWithID:self.orderID success:^(NSDictionary *response){
        [self.hud hide:YES];
        NSLog(@"订单详情是%@",response);
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [TakeAwayOrderDetail mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"goodsDetail":@"TakeAwayOrderGood"
                       };
            }];
            self.orderDetail = [TakeAwayOrderDetail mj_objectWithKeyValues:(NSDictionary *)response[@"data"]];
            self.orderState = self.orderDetail.state;
            [self showRedButtonWithOrderState:self.orderState];
            [self.tableView reloadData];
            // 成功
        } else {
            // 失败
        }
    } failure:^(NSString *error){
        [self.hud hide:YES];
        [PresentationUtility showTextDialog:self.view text:@"网络错误，请重试" success:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderDetail) {
        if (section == 0) {
            if (self.orderDetail.state == 0 || self.orderDetail.state == 1 || self.orderDetail.state == 3 || self.orderDetail.state == 4 || self.orderDetail.state == 5) {
                NSLog(@"有白按钮");
                return self.orderDetail.goodsDetail.count + 1 + 1 + 1;
            }
            else {
                NSLog(@"没有白按钮");
                return self.orderDetail.goodsDetail.count + 1 + 1;
            }
        } else {
            return 5;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderDetail) {
        if (indexPath.section == 0) {
            if (indexPath.row < self.orderDetail.goodsDetail.count) {
                FoodBillCell *cell = [FoodBillCell cellForTableView:tableView];
                NSInteger count = [(TakeAwayOrderGood *)self.orderDetail.goodsDetail[indexPath.row] num];
                cell.count.text = [NSString stringWithFormat:@"*%lu",(unsigned long)count];
                CGFloat price = [(TakeAwayOrderGood *)self.orderDetail.goodsDetail[indexPath.row] price];
                cell.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",price/100];
                cell.foodName.text = [(TakeAwayOrderGood *)self.orderDetail.goodsDetail[indexPath.row] goodsName];
                return cell;
            } else if (indexPath.row == self.orderDetail.goodsDetail.count) {
                FoodShippingFeeCell *cell = [FoodShippingFeeCell cellForTableView:tableView];
                NSInteger packFee = self.orderDetail.packFee;
                cell.price.text = [NSString stringWithFormat:@"￥%.1f",packFee/100.0];
                return cell;
            } else if (indexPath.row == self.orderDetail.goodsDetail.count + 1) {
                GMMeTakeAwayDetailTotalFeeCell *cell = [GMMeTakeAwayDetailTotalFeeCell cellForTableView:tableView];
                cell.totalFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",self.orderDetail.totalFee/100.0];
                return cell;
            } else {
                GMMeTakeAwayDetailButtonCell *cell = [GMMeTakeAwayDetailButtonCell cellForTableView:tableView];
                [cell.oneMoreOrderButton addTarget:self action:@selector(oneMoreOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.cancelOrderButton addTarget:self action:@selector(cancelOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                switch (self.orderDetail.state) {
                    case 0:
                        cell.cancelOrderButton.hidden = NO;
                        break;
                    case 1:
                        cell.cancelOrderButton.hidden = NO;
                        break;
                    case 3:
                        cell.confirmButton.hidden = NO;
                        break;
                    case 4:
                        cell.oneMoreOrderButton.hidden = NO;
                        break;
                    case 5:
                        cell.oneMoreOrderButton.hidden = NO;
                        break;
                    default:
                        break;
                }
                return cell;
            }
        } else {
            GMMeTakeAwayDetailInfoCell *cell = [GMMeTakeAwayDetailInfoCell cellForTableView:tableView];
            if (indexPath.row == 0) {
                cell.contentLabel1.text = @"配送方：";
                cell.contentLabel2.text = @"商家配送";
            } else if (indexPath.row == 1) {
                cell.contentLabel1.text = @"订单编号：";
                cell.contentLabel2.text = [NSString stringWithFormat:@"%li",(long)self.orderID];
            } else if (indexPath.row == 2) {
                cell.contentLabel1.text = @"收货信息：";
                cell.contentLabel2.text = @"......";
            } else if (indexPath.row == 3) {
                cell.contentLabel1.text = @"送达时间：";
                NSInteger time = self.orderDetail.arriveTime;
                cell.contentLabel2.text = [NSString convertTimeUntilSecond:[NSNumber numberWithInteger:time]];
            } else if (indexPath.row == 4) {
                cell.contentLabel1.text = @"支付方法：";
                cell.contentLabel2.text = @"支付宝";
            }
            return cell;
        }
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderDetail) {
        if (indexPath.section == 0) {
            if (indexPath.row < self.orderDetail.goodsDetail.count) {
                return 30.0;
            } else {
                return 44.0;
            }
        } else {
            return 36.0;
        }
    } else {
        return 44.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        title.text = self.orderDetail.store.name;
        title.font = [UIFont systemFontOfSize:16.0];
        title.textColor = GMFontColor;
        title.frame = CGRectMake(15, 5, 100, 20);
        
        UILabel *title2 = [[UILabel alloc] init];
        [view addSubview:title2];
        if (self.orderDetail) {
            switch (self.orderDetail.state) {
                case 0:
                    title2.text = @"等待支付";
                    break;
                case 1:
                    title2.text = @"支付成功";
                    break;
                case 2:
                    title2.text = @"等待发货";
                    break;
                case 3:
                    title2.text = @"商家已送达";
                    break;
                case 4:
                    title2.text = @"订单完成";
                    break;
                case 5:
                    title2.text = @"订单完成并评论";
                    break;
                case 6:
                    title2.text = @"支付失败";
                    break;
                case 7:
                    title2.text = @"订单撤销";
                    break;
                case 8:
                    title2.text = @"接单失败";
                    break;
                case 9:
                    if (self.refundState == 5) {
                        title2.text = @"退款开始";
                    } else if (self.refundState == 4) {
                        title2.text = @"退款失败";
//                        title2.text = @"申请已提交／等待商家确认";
                    } else if (self.refundState == 3) {
                        title2.text = @"退款完成";
                    } else if (self.refundState == 2) {
                        title2.text = @"商家拒绝退款";
                    } else if (self.refundState == 1) {
                        title2.text = @"处理中";
                    } else if (self.refundState == 0) {
                        title2.text = @"申请已提交";
                    }
                    break;
                default:
                    title2.text = @"";
                    break;
            }
        }
        title2.font = [UIFont systemFontOfSize:12.0];
        title2.textColor = GMBrownColor;
        title2.frame = CGRectMake(100, 5, 100, 20);
        [title2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
        [title2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:239.0/255.0];
        line.frame = CGRectMake(0, 31, kScreenWidth, 0.5);
        [view addSubview:line];
        [view addSubview:title];
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"订单明细";
        title.font = [UIFont systemFontOfSize:12.0];
        title.textColor = GMFontColor;
        title.frame = CGRectMake(15, 5, 100, 20);
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = GMBrownColor;
        line.frame = CGRectMake(0, 31, kScreenWidth, 0.5);
        [view addSubview:line];
        [view addSubview:title];
        return view;
    }
}

#pragma mark - private methods
- (void)showRedButtonWithOrderState:(NSInteger)orderState {
    switch (orderState) {
        case 0:
            self.payButton.hidden = NO;
            break;
        case 2:
            self.refundButton.hidden = NO;
            break;
        case 3:
            self.refundButton.hidden = NO;
            break;
        case 4:
            self.evaluateButton.hidden = NO;
            break;
        case 6:
            self.reorderButton.hidden = NO;
            break;
        case 7:
            self.reorderButton.hidden = NO;
            break;
        case 8:
            self.changeStore.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)hideRedButton {
    self.payButton.hidden = YES;
    self.refundButton.hidden = YES;
    self.evaluateButton.hidden = YES;
    self.reorderButton.hidden = YES;
    self.changeStore.hidden = YES;
}

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
            }];
        } else {
            NSLog(@"下单失败");
        }
    } failure:^(NSString *error){
        NSLog(@"网络请求异常");
    }];
}

#pragma mark - event response
// white button
- (void)oneMoreOrderButtonClicked:(id)sender {
    FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
    vc.restaurantName = self.orderDetail.store.name;
    vc.restaurantID = [NSString stringWithFormat:@"%li",self.orderDetail.store.storeId];
    vc.shippingFee = self.orderDetail.packFee / 100.0;
    vc.bargainFee = 0;
    vc.totalPrice = self.orderDetail.totalFee / 100.0;
    vc.costTime = 50;
    for (int i = 0; i < self.orderDetail.goodsDetail.count; i++) {
        FoodOrderViewBaseItem *item = [[FoodOrderViewBaseItem alloc] initWithTakeAwayOrderGood:self.orderDetail.goodsDetail[i]];
        [vc.foodArray addObject:item];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelOrderButtonClicked:(id)sender {
    [NetworkFetcher foodCancelOrderWithOrderID:(long)self.orderID success:^(NSDictionary *response){
        [PresentationUtility showTextDialog:self.view text:@"取消订单成功" success:^{
        }];
        
    } failure:^(NSString *error){
        [PresentationUtility showTextDialog:self.view text:@"取消订单失败" success:^{
        }];
    }];
}

- (void)confirmButtonClicked:(id)sender {
    [NetworkFetcher foodConfirmOrderWithOrderID:(long)self.orderID storeID:self.orderDetail.store.storeId success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [PresentationUtility showTextDialog:self.view text:@"确认收货成功" success:^{
            }];
        }
    } failure:^(NSString *error) {
        [PresentationUtility showTextDialog:self.view text:@"确认收货失败" success:^{
        }];
    }];
}

// red button
- (IBAction)refundButtonClicked:(id)sender {
    GMMeTakeAwayRefundViewController *vc = [[GMMeTakeAwayRefundViewController alloc] init];
    vc.orderID = self.orderID;
    vc.totalPrice = self.orderDetail.totalFee / 100.0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeStoreButtonClicked:(id)sender {
    // 换店铺点击
    NSLog(@"换个店铺按钮点击");
    FoodViewController *vc = [[FoodViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reorderButtonClicked:(id)sender {
    // 重新下单点击
    FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
    vc.restaurantName = self.orderDetail.store.name;
    vc.restaurantID = [NSString stringWithFormat:@"%li",self.orderDetail.store.storeId];
    vc.shippingFee = self.orderDetail.packFee / 100.0;
    vc.bargainFee = 0;
    vc.totalPrice = self.orderDetail.totalFee / 100.0;
    vc.costTime = 50;
    for (int i = 0; i < self.orderDetail.goodsDetail.count; i++) {
        FoodOrderViewBaseItem *item = [[FoodOrderViewBaseItem alloc] initWithTakeAwayOrderGood:self.orderDetail.goodsDetail[i]];
        [vc.foodArray addObject:item];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)payButtonClicked:(id)sender {
    // 支付点击
    [self prepayWithOrderID:(long)self.orderID];
}

- (IBAction)evaluateButtonClicked:(id)sender {
    // 评价点击
    GMMeTakeAwayRatingViewController *vc = [[GMMeTakeAwayRatingViewController alloc] init];
    vc.name = self.orderDetail.store.name;
    vc.storeIconURL = self.orderDetail.store.icon;
    vc.storeID = self.orderDetail.store.storeId;
    vc.orderID = self.orderID;
    vc.deliveryTime = 123;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getters and setters
- (void)setOrderState:(NSInteger)orderState {
    _orderState = orderState;
}

- (void)setRefundState:(NSInteger)refundState {
    _refundState = refundState;
}

@end
