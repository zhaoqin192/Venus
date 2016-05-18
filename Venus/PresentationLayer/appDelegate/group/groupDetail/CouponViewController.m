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
    
//    [self.tableView registerClass:[CouponPictureCell class] forCellReuseIdentifier:@"CouponPictureCell"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}

- (void)bindViewMode{
    
    self.viewModel = [[CouponDetailViewModel alloc] init];
    
    [self.viewModel.commentSuccessObject subscribeNext:^(id x) {
        
//        [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(id x) {
        
    }];
    
    @weakify(self)
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
//        CouponPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponPictureCell"];
        
        CouponPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponPictureCell"];
        
        cell.button.layer.cornerRadius = 5;

        cell.abstract.text = self.couponModel.abstract;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.couponModel.pictureUrl]];
        cell.price.text = [NSString stringWithFormat:@"原价￥%@", self.couponModel.price];
        cell.asPrice.text = [NSString stringWithFormat:@"￥%@", self.couponModel.asPrice];
        cell.sales.text = [NSString stringWithFormat:@"已售%@", self.couponModel.purchaseNum];
        [[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            NSLog(@"button clicked");
        }];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        CouponStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreCell"];
        cell.storeName.text = self.couponModel.name;
        cell.storeAddress.text = [NSString stringWithFormat:@"地址:%@", self.couponModel.address];
        [[cell.contactButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            NSLog(@"contact clicked");
        }];
        return cell;
    }
    else if (indexPath.section == 2) {
        CouponCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCaseCell"];
//        cell.abstract.text = self.couponModel.abstract;
        cell.price.text = [NSString stringWithFormat:@"￥%@", self.couponModel.asPrice];
        cell.number.text = @"1张";
        return cell;
    }
    else if (indexPath.section == 3) {
        CouponInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponInformationCell"];
        
        NSString *startTime = [self.viewModel convertTime:self.couponModel.startTime];
        NSString *endTime = [self.viewModel convertTime:self.couponModel.endTime];
        cell.validity.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
        
        return cell;
    }
    else if (indexPath.section == 4) {
        CouponCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCommentCell"];
//        CouponCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row];
//    
//        cell.name.text = model.userName;
//        NSString *time = [self.viewModel convertTime:model.time];
//        cell.time.text = time;
////        cell.content.text = @"奥修说过，我们一直是头脑的奴隶，过份的“理性”堵塞了我们去感受一个美好世界的通道。从头脑下落，跟心生活在一起。";
//        cell.imageArray = model.pictureArray;
//        cell.content.text = model.content;
//        
//        [cell updateCollection];
//        
        return cell;
    }
    else {
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 255;
        
        
//        return [tableView fd_heightForCellWithIdentifier:@"CouponPictureCell" cacheByIndexPath:indexPath configuration:^(CouponPictureCell *cell) {
//            cell.button.layer.cornerRadius = 5;
//            
//            cell.abstract.text = self.couponModel.abstract;
//            [cell.image sd_setImageWithURL:[NSURL URLWithString:self.couponModel.pictureUrl]];
//            cell.price.text = [NSString stringWithFormat:@"原价￥%@", self.couponModel.price];
//            cell.asPrice.text = [NSString stringWithFormat:@"￥%@", self.couponModel.asPrice];
//            cell.sales.text = [NSString stringWithFormat:@"已售%@", self.couponModel.purchaseNum];
//            [[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside]
//             subscribeNext:^(id x) {
//                 NSLog(@"button clicked");
//             }];
//        }];
    }
//    else if (indexPath.section == 1) {
//        
//        return [tableView fd_heightForCellWithIdentifier:@"CouponStoreCell" cacheByIndexPath:indexPath configuration:^(CouponStoreCell *cell) {
//            cell.storeName.text = self.couponModel.name;
//            cell.storeAddress.text = [NSString stringWithFormat:@"地址:%@", self.couponModel.address];
//            [[cell.contactButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//             subscribeNext:^(id x) {
//                 NSLog(@"contact clicked");
//             }];
//        }];
//        
//        
////        return 110;
//    }
//    else if (indexPath.section == 2) {
//        
//        return [tableView fd_heightForCellWithIdentifier:@"CouponCaseCell" cacheByIndexPath:indexPath configuration:^(CouponCaseCell *cell) {
//            cell.price.text = [NSString stringWithFormat:@"￥%@", self.couponModel.asPrice];
//            cell.number.text = @"1张";
//        }];
//        
//        
//        
////        return 90;
//    }
//    else if (indexPath.section == 3) {
////        return 110;
//        
//        return [tableView fd_heightForCellWithIdentifier:@"CouponInformationCell" cacheByIndexPath:indexPath configuration:^(CouponInformationCell *cell) {
//            NSString *startTime = [self.viewModel convertTime:self.couponModel.startTime];
//            NSString *endTime = [self.viewModel convertTime:self.couponModel.endTime];
//            cell.validity.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
//        }];
//    }
//
////    return 330;
//    
//    
//    return [tableView fd_heightForCellWithIdentifier:@"CouponCommentCell" cacheByIndexPath:indexPath configuration:^(CouponCommentCell *cell) {
//        CouponCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row];
//        
//        cell.name.text = model.userName;
//        NSString *time = [self.viewModel convertTime:model.time];
//        cell.time.text = time;
//        cell.content.text = @"奥修说过，我们一直是头脑的奴隶，过份的“理性”堵塞了我们去感受一个美好世界的通道。从头脑下落，跟心生活在一起。";
////        cell.content.text = model.content;
//    }];
    
    return 0;
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


@end
