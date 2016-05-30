//
//  CouponViewController.m
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponModel.h"
#import "CouponDetailViewModel.h"
#import "RootTabViewController.h"
#import "CouponPictureCell.h"
#import "CouponStoreCell.h"
#import "CouponCaseCell.h"
#import "CouponInformationCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CouponCommentCell.h"
#import "MBProgressHUD.h"
#import "CouponCommentModel.h"
#import "CommitOrderViewController.h"
#import "NSString+Expand.h"


@interface CouponViewController ()

@property (nonatomic, strong) CouponDetailViewModel *viewModel;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"团购劵详情";
    
    [self bindViewMode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    [self.viewModel fetchCommentWithCouponID:self.couponModel.identifier page:[NSNumber numberWithInteger:self.viewModel.currentPage]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}

- (void)bindViewMode{
    
    self.viewModel = [[CouponDetailViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.commentSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return self.viewModel.commentArray.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CouponPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponPictureCell"];
        
        cell.button.layer.cornerRadius = 5;
        cell.abstract.text = self.couponModel.abstract;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.couponModel.pictureUrl]];
        cell.price.text = [NSString stringWithFormat:@"原价￥%.2f", [self.couponModel.asPrice floatValue] / 100];
        cell.asPrice.text = [NSString stringWithFormat:@"￥%.2f", [self.couponModel.price floatValue] / 100];
        cell.sales.text = [NSString stringWithFormat:@"已售%@", self.couponModel.purchaseNum];
        [[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            NSLog(@"button clicked");
        }];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        CouponStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreCell"];
        
        [self configureStoreCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == 2) {
        CouponCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCaseCell"];

        cell.price.text = [NSString stringWithFormat:@"￥%@", self.couponModel.asPrice];
        cell.number.text = @"1张";
        return cell;
    }
    else if (indexPath.section == 3) {
        CouponInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponInformationCell"];
    
        cell.validity.text = [NSString stringWithFormat:@"%@至%@", [NSString convertTime:self.couponModel.startTime] , [NSString convertTime:self.couponModel.endTime]];
        
        return cell;
    }
    
    CouponCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCommentCell"];
    
    [self configureCommentCell:cell atIndexPath:indexPath];
    
    return cell;

}

- (void)configureCommentCell:(CouponCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CouponCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row];
    
    cell.name.text = model.userName;
    cell.time.text = [NSString convertTime:model.time];
    cell.content.text = model.content;

}

- (void)configureStoreCell:(CouponStoreCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.storeName.text = self.couponModel.name;
    cell.storeAddress.text = [NSString stringWithFormat:@"地址:%@", self.couponModel.address];
    @weakify(self)
    [[cell.contactButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         
         @strongify(self)
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打商家电话" message:self.couponModel.phone  preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             NSString *phoneNumber = [@"tel://" stringByAppendingString:self.couponModel.phone];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
         }];
         [alertController addAction:cancelAction];
         [alertController addAction:callAction];
         [self presentViewController:alertController animated:YES completion:nil];
         
     }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    if (indexPath.section == 0) {
        return 255;
    }
    else if (indexPath.section == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:@"CouponStoreCell" configuration:^(CouponStoreCell *cell) {
            @strongify(self)
            [self configureStoreCell:cell atIndexPath:indexPath];
            
        }];
        
    }
    else if (indexPath.section == 2) {
        return 90;
    }
    else if (indexPath.section == 3) {
        return 110;
    }
    return [tableView fd_heightForCellWithIdentifier:@"CouponCommentCell" configuration:^(id cell) {
        @strongify(self)
        [self configureCommentCell:cell atIndexPath:indexPath];
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark -prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CommitOrder"]) {
        CommitOrderViewController *commitVC = segue.destinationViewController;
        commitVC.couponModel = self.couponModel;
    }
}

@end
