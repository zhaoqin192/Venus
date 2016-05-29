//
//  FoodSubmitOrderViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodSubmitOrderViewController.h"
#import "FoodAddAddressCell.h"
#import "FoodPaymentCell.h"
#import "FoodBillCell.h"
#import "FoodShippingFeeCell.h"
#import "FoodOrderViewBaseItem.h"
#import "FoodOtherCell.h"
#import "FoodOrderAddAddressViewController.h"
#import "NetworkFetcher+FoodAddress.h"
#import "MBProgressHUD.h"
#import "PresentationUtility.h"
#import "FoodAddressManager.h"
#import "FoodShowAddressCell.h"
#import "FoodAddressSelectionViewController.h"
#import "Restaurant.h"
#import "FoodOrder.h"
#import "FoodAddress.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "NetworkFetcher+FoodOrder.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "NSString+Expand.h"
#import "PaymentSuccessViewController.h"
#import "GMMeTakeAwayViewController.h"

@interface FoodSubmitOrderViewController () <UITableViewDelegate, UITableViewDataSource, FoodAddressSelectionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bargain;
@property (weak, nonatomic) IBOutlet UILabel *haveToPay;
@property (assign, nonatomic) CGFloat finalPrice;
@property (strong, nonatomic) FoodAddressManager *foodAddressManager;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) NSInteger addressSelectionIndex;


@end

@implementation FoodSubmitOrderViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.finalPrice = self.totalPrice - self.bargainFee + self.shippingFee;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self hideSelf];
    [self getDeliveryTime];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceed:) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed:) name:@"PayFailure" object:nil];
    // 做登录检测
    DatabaseManager *manager = [DatabaseManager sharedInstance];
    if ([manager.accountDao isLogin]) {
        [NetworkFetcher foodFetcherUserFoodAddresWithRestaurantID:self.restaurantID success:^{
            [self.hud hide:YES];
            [self showSelf];
        } failure:^(NSString *error) {
            NSLog(@"错误是：%@",error);
        }];
    } else {
        [PresentationUtility showTextDialog:self.view text:@"请先登录" success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"提交订单";
    _bargain.text = [NSString stringWithFormat:@"￥%.1f",_bargainFee];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [NetworkFetcher foodFetcherUserFoodAddresWithRestaurantID:self.restaurantID success:^{
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        NSLog(@"错误是：%@",error);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            if (self.foodArray.count != 0) {
                return self.foodArray.count + 1;
            } else {
                return 1;
            }
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.foodAddressManager.foodAddressArray.count == 0) {
            FoodAddAddressCell *cell = [FoodAddAddressCell cellForTableView:tableView];
            return cell;
        } else {
            FoodShowAddressCell *cell = [FoodShowAddressCell cellForTableView:tableView];
            if (self.addressSelectionIndex < self.foodAddressManager.foodAddressArray.count) {
                cell.foodAddress = (FoodAddress *)self.foodAddressManager.foodAddressArray[_addressSelectionIndex];
            } else {
                cell.foodAddress = (FoodAddress *)self.foodAddressManager.foodAddressArray[0];
            }
            cell.selectionImage.hidden = YES;
            return cell;
        }
    } else if (indexPath.section == 1) {
        FoodPaymentCell *cell = [FoodPaymentCell  cellForTableView:tableView];
        if (indexPath.row == 0) {
            cell.paymentWay.text = @"支付宝";
            cell.isSelected = YES;
        }
        return cell;
    } else if (indexPath.section == 2){
        if (self.foodArray.count != 0) {
            if (indexPath.row == self.foodArray.count) {
                FoodShippingFeeCell *cell = [FoodShippingFeeCell cellForTableView:tableView];
                cell.price.text = [NSString stringWithFormat:@"￥%.1f",_shippingFee];
                return cell;
            } else {
                FoodBillCell *cell = [FoodBillCell cellForTableView:tableView];
                FoodOrderViewBaseItem *baseItem = (FoodOrderViewBaseItem *)self.foodArray[indexPath.row];
                cell.foodName.text = baseItem.name;
                cell.count.text = [NSString stringWithFormat:@"*%li",(long)baseItem.orderCount];
                CGFloat totalPrice = baseItem.orderCount * baseItem.unitPrice;
                cell.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else if (indexPath.section == 3) {
        FoodOtherCell *cell = [FoodOtherCell cellForTableView:tableView];
        if (indexPath.row == 0) {
            cell.arrow.hidden = YES;
            cell.content.text = @"送达时间";
            cell.content2.text = @"立即配送";
            NSString *content3 = [self getDeliveryTime];
            NSMutableAttributedString *estimatedTime = [[NSMutableAttributedString alloc] initWithString:content3];
            [estimatedTime addAttribute:NSForegroundColorAttributeName value:GMRedColor range:NSMakeRange(0, content3.length)];
            cell.content3.attributedText = estimatedTime;
        } else {
            cell.content.text = @"备注";
            cell.content2.text = @"(选填)";
            cell.content2.textColor = GMFontColor;
            cell.content3.text = @"可输入特殊要求";
            cell.content3.textColor = GMFontColor;
        }
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"支付方式";
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = GMFontColor;
        title.frame = CGRectMake(15, 5, 100, 20);
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = GMBrownColor;
        line.frame = CGRectMake(0, 31, kScreenWidth, 0.5);
        [view addSubview:line];
        [view addSubview:title];
        return view;
    } else if (section == 2) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(45, 5, 100, 20);
        if (_restaurantName) {
            title.text = _restaurantName;
        } else {
            title.text = @"店铺名称";
        }
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = GMFontColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store"]];
        imageView.frame = CGRectMake(15, 4, 24, 24);
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = GMBrownColor;
        line.frame = CGRectMake(0, 31, kScreenWidth, 0.5);
        [view addSubview:line];
        [view addSubview:title];
        [view addSubview:imageView];
        return view;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10.0;
            break;
        case 1:
            return 32.0;
        case 2:
            return 32.0;
        default:
            return 10.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10.0;
            break;
        case 1:
            return 10.0;
            break;
        default:
            return 0.1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (self.foodAddressManager.foodAddressArray.count == 0) {
                return 44;
            } else {
                return 68;
            }
            break;
        case 2:
            if (_foodArray.count > 0) {
                if (indexPath.row < _foodArray.count) {
                    return 30.0;
                } else {
                    return 44.0;
                }
            } else {
                return 44.0;
            }
            break;
        default:
            return 44.0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.foodAddressManager.foodAddressArray.count == 0) {
                FoodOrderAddAddressViewController *vc = [[FoodOrderAddAddressViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                FoodAddressSelectionViewController *vc = [[FoodAddressSelectionViewController alloc] init];
                vc.selectedIndex = self.addressSelectionIndex;
                vc.restaurantID = self.restaurantID;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
}

#pragma mark - FoodAddressSelectionViewControllerDelegate
- (void)foodAddressSelectionViewController:(FoodAddressSelectionViewController *)vc didSelectIndex:(NSInteger)index {
    self.addressSelectionIndex = index;
}

#pragma mark - private methods
- (void)hideSelf {
    self.bottomView.hidden = YES;
    self.tableView.hidden = YES;
}

- (void)showSelf {
    self.bottomView.hidden = NO;
    self.tableView.hidden = NO;
}

- (NSString *)getDeliveryTime {
    NSDate *date = [NSDate date];
    NSInteger interval = _costTime * 60;
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *deliveryTime = [formatter stringFromDate:localDate];
    return [NSString stringWithFormat:@"(预计%@送达)",deliveryTime];
}

- (NSTimeInterval)getDeliveryTimeSince1970 {
    NSDate *date = [NSDate date];
    NSInteger interval = _costTime * 60;
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    return [localDate timeIntervalSince1970] * 1000;
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

- (void)paySucceed:(id)sender {
    GMMeTakeAwayViewController *vc = [[GMMeTakeAwayViewController alloc] init];
    [PresentationUtility showTextDialog:self.view text:@"支付成功" success:^{
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)payFailed:(id)sender {
    GMMeTakeAwayViewController *vc = [[GMMeTakeAwayViewController alloc] init];
    [PresentationUtility showTextDialog:self.view text:@"支付失败" success:^{
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - event response
- (IBAction)confirmOrderButtonClicked:(id)sender {

    if (self.foodAddressManager.foodAddressArray.count == 0) {
        [PresentationUtility showTextDialog:self.view text:@"请先填写地址" success:nil];
    } else {
        FoodOrder *order = [[FoodOrder alloc] init];
        order.storeID = self.restaurantID;
        FoodAddress *selectedAddress = (FoodAddress *)self.foodAddressManager.foodAddressArray[self.addressSelectionIndex];
        order.recipient = selectedAddress.linkmanName;
        order.phoneNumber = selectedAddress.phoneNumber;
        order.address = selectedAddress.address;
        order.remark = @"";
        order.payStatus = AliPay;
        order.arriveTime = (long)[self getDeliveryTimeSince1970];
        order.foodDetail = [[NSMutableDictionary alloc] init];
        NSLog(@"点单数%lu",(unsigned long)self.foodArray.count);
        for (FoodOrderViewBaseItem *item in self.foodArray) {
            [order.foodDetail setObject:@(item.orderCount) forKey:item.identifier];
        }
        NSLog(@"时间是%li",order.arriveTime);
        NSLog(@"点单情况是%@",order.foodDetail);
        [NetworkFetcher foodCreateOrder:order success:^(NSDictionary *response) {
            NSLog(@"返回orderID是%@",response[@"orderId"]);
            [self prepayWithOrderID:[(NSString *)response[@"orderId"] longValue]];
        } failure:^(NSString *error) {
            NSLog(@"error");
        }];
    }
    
    
}

#pragma mark - getters and setters

- (NSMutableArray *)foodArray {
    if (!_foodArray) {
        _foodArray = [[NSMutableArray alloc] init];
    }
    return _foodArray;
}

- (NSString *)restaurantName {
    if (!_restaurantName) {
        _restaurantName = @"";
    }
    return _restaurantName;
}

- (FoodAddressManager *)foodAddressManager {
    if (!_foodAddressManager) {
        _foodAddressManager = [FoodAddressManager sharedInstance];
    }
    return _foodAddressManager;
}

- (void)setFinalPrice:(CGFloat)finalPrice {
    _finalPrice = finalPrice;
    _haveToPay.text = [NSString stringWithFormat:@"￥%.2f",finalPrice];
}

@end
