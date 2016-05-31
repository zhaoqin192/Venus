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

@interface GMMeTakeAwayDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TakeAwayOrderDetail *orderDetail;

#pragma mark - redButton
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeStore;

@end

@implementation GMMeTakeAwayDetailViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"订单详情";
    self.navigationController.navigationBar.translucent = NO;
    [NetworkFetcher foodFetcherUserFoodOrderDetailWithID:self.orderID success:^(NSDictionary *response){
        NSLog(@"订单详情是%@",response);
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [TakeAwayOrderDetail mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"goodsDetail":@"TakeAwayOrderGood"
                       };
            }];
            self.orderDetail = [TakeAwayOrderDetail mj_objectWithKeyValues:(NSDictionary *)response[@"data"]];
            [self.tableView reloadData];
            // 成功
        } else {
            // 失败
        }
    } failure:^(NSString *error){
        
    }];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    [self.rdv_tabBarController setTabBarHidden:NO];
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
        title.text = @"店铺名称";
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
                    if (self.orderDetail.refundState == 5) {
                        title2.text = @"退款成功";
                    } else {
                        title2.text = @"退款过程中";
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

#pragma mark - event response
// white button
- (void)oneMoreOrderButtonClicked:(id)sender {
    // 再来一单点击
}

- (void)cancelOrderButtonClicked:(id)sender {
    // 取消订单点击
}

- (void)confirmButtonClicked:(id)sender {
    // 确认订单点击
}

// red button
- (IBAction)refundButtonClicked:(id)sender {
    // 退款点击
}

- (IBAction)changeStoreButtonClicked:(id)sender {
    // 换店铺点击
}

- (IBAction)reorderButtonClicked:(id)sender {
    // 重新下单点击
}

- (IBAction)payButtonClicked:(id)sender {
    // 支付点击
}

- (IBAction)evaluateButtonClicked:(id)sender {
    // 评价点击
}


#pragma mark - getters and setters
- (void)setOrderState:(NSInteger)orderState {
    _orderState = orderState;
}

- (void)setRefundState:(NSInteger)refundState {
    _refundState = refundState;
}

@end
