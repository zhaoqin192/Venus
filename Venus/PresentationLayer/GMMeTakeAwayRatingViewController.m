//
//  GMMeTakeAwayRatingViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayRatingViewController.h"
#import "GMMeTakeAwayRatingCell.h"
#import "GMMeTakeAwayRatingStarCell.h"
#import "GMMeTakeAwayRefundReasonCell.h"
#import "NetworkFetcher+FoodOrder.h"
#import "PresentationUtility.h"

@interface GMMeTakeAwayRatingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;

@property (copy, nonatomic) NSString *commentContent;

@end

@implementation GMMeTakeAwayRatingViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.storeName.text = self.name;
    [self.storeIcon sd_setImageWithURL:[NSURL URLWithString:self.storeIconURL]];
    self.navigationItem.title = @"评价";
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
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GMMeTakeAwayRatingCell *cell = [GMMeTakeAwayRatingCell cellForTableView:tableView];
            cell.content1.text = @"送餐速度";
            cell.content2.text = @"xxx分钟";
            return cell;
        } else {
            GMMeTakeAwayRatingStarCell *cell = [GMMeTakeAwayRatingStarCell cellForTableView:tableView];
            return cell;
        }
    }  else {
        GMMeTakeAwayRefundReasonCell *cell = [GMMeTakeAwayRefundReasonCell cellForTableView:tableView];
        cell.textField.placeholder = @"请在此输入您的宝贵意见";
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 100.0;
    } else {
        return 56.0;
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
    NSLog(@"提交评论");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    GMMeTakeAwayRefundReasonCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.commentContent = cell.textField.text;
    [NetworkFetcher foodUserCreateCommentWithOrderId:self.orderID deliveryTime:self.deliveryTime foodGrade:4 content:self.commentContent storeId:self.storeID pictures:@[] success:^(NSDictionary *response) {
        NSLog(@"评论成功了!");
        [PresentationUtility showTextDialog:self.view text:@"评论成功" success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString *error) {
    
    }];
}

#pragma mark - getters and setters
- (NSString *)commentContent {
    if (!_commentContent) {
        _commentContent = @"";
    }
    return _commentContent;
}


@end
