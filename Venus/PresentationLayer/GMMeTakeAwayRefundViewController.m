//
//  GMMeTakeAwayRefundViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayRefundViewController.h"
#import "GMMeTakeAwayRefundViewCell.h"
#import "GMMeTakeAwayDetailInfoCell.h"
#import "GMMeTakeAwayRefundReasonCell.h"
#import "NetworkFetcher+FoodOrder.h"

@interface GMMeTakeAwayRefundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *reason;


@end

@implementation GMMeTakeAwayRefundViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"申请退款";
    self.navigationController.navigationBar.translucent = NO;
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    [self.rdv_tabBarController setTabBarHidden:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GMMeTakeAwayDetailInfoCell *cell = [GMMeTakeAwayDetailInfoCell cellForTableView:tableView];
        cell.contentLabel1.text = @"订单编号";
        cell.contentLabel2.text = [NSString stringWithFormat:@"%li",self.orderID];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GMMeTakeAwayDetailInfoCell *cell = [GMMeTakeAwayDetailInfoCell cellForTableView:tableView];
            cell.contentLabel1.text = @"退款金额";
            cell.contentLabel2.textColor = GMRedColor;
            cell.contentLabel2.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            return cell;
        } else {
            GMMeTakeAwayRefundViewCell *cell = [GMMeTakeAwayRefundViewCell cellForTableView:tableView];
            cell.content1.text = @"现金";
            cell.content2.text = @"返回原账户";
            return cell;
        }
    } else {
        GMMeTakeAwayRefundReasonCell *cell = [GMMeTakeAwayRefundReasonCell cellForTableView:tableView];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 150.0;
    } else {
        return 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

#pragma mark - private methods

#pragma mark - event response
- (IBAction)submitButtonClicked:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    GMMeTakeAwayRefundReasonCell *cell = (GMMeTakeAwayRefundReasonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.reason = cell.textField.text;
    [NetworkFetcher foodRefundOrderWithOrderId:self.orderID reason:self.reason success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            // 成功退款
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请成功" message:@"退款预计一周内返回原账户" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failure:^(NSString *error) {
    
    }];
}

#pragma mark - getters and setters

- (NSString *)reason {
    if (!_reason) {
        _reason = @"";
    }
    return _reason;
}


@end
