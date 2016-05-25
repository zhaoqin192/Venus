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

@interface FoodSubmitOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bargain;
@property (weak, nonatomic) IBOutlet UILabel *haveToPay;

@end

@implementation FoodSubmitOrderViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (_foodArray) {
        NSLog(@"长度是%lu",(unsigned long)_foodArray.count);
    } else {
        NSLog(@"!!!!!!!!!!!!");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"提交订单";
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark -- UITableViewDataSource

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
        FoodAddAddressCell *cell = [FoodAddAddressCell cellForTableView:tableView];
        return cell;
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
                self.shippingFee = 20.0;
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
            NSString *content3 = @"(预计11:24送达)";
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

#pragma mark -- UITableViewDelegate

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
    if (indexPath.section == 1) {
    }
}

#pragma mark - event response

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

@end
