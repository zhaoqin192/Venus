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
#import "CouponCommentTitleCell.h"
#import "HCSStarRatingView.h"
#import "ShowImageViewController.h"
#import "MWPhotoBrowser.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "WebViewController.h"


@interface CouponViewController ()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) CouponDetailViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"团购劵详情";
    
    [self bindViewMode];
    
    [self.viewModel fetchDetailWithCouponID:self.couponModel.identifier];
    
    [self.viewModel fetchCommentWithCouponID:self.couponModel.identifier page:[NSNumber numberWithInteger:self.viewModel.currentPage]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [MobClick beginLogPageView:@"CouponViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [MobClick endLogPageView:@"CouponViewController"];
    
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
    
    [self.viewModel.detailSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.viewModel.detailFailureObject subscribeNext:^(id x) {
        
    }];
    
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showCommentImage" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        UIStoryboard *showImage = [UIStoryboard storyboardWithName:@"couponComment" bundle:nil];
        ShowImageViewController *showImageVC = [showImage instantiateViewControllerWithIdentifier:@"ShowImageViewController"];
        showImageVC.image = userInfo[@"image"];
        [self.navigationController pushViewController:showImageVC animated:NO];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:CouponCommentCellImageEvent object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        
        
        // Browser
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        
        NSArray *imageArray = userInfo[@"imageArray"];
        for (NSString *imageURL in imageArray) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageURL]]];
        }
        
        self.photos = photos;
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:[userInfo[@"item"] integerValue]];
        
        // Modal
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        
    }];
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return self.viewModel.commentArray.count + 1;
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
        if (!self.viewModel.backable) {
            cell.backableView.hidden = YES;
        }
        else {
            cell.backableView.hidden = NO;
        }
        if (!self.viewModel.mustOrder) {
            cell.mustOrderView.hidden = NO;
        }
        else {
            cell.mustOrderView.hidden = YES;
        }
        
        return cell;
    }
    else if (indexPath.section == 1) {
        CouponStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreCell"];
        [self configureStoreCell:cell atIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 2) {
        CouponCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCaseCell"];
        if ([self.viewModel.type isEqualToNumber:@0]) {
            cell.abstract.text = @"代金券";
        }
        else {
            cell.abstract.text = @"套餐劵";
        }
        cell.price.text = [NSString stringWithFormat:@"￥%.2f", [self.couponModel.price floatValue] / 100];
        cell.number.text = @"1张";
        @weakify(self)
        [[[cell.moreDetail rac_signalForControlEvents:UIControlEventTouchUpInside]
        takeUntil:cell.rac_prepareForReuseSignal]
        subscribeNext:^(id x) {
            @strongify(self)
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = self.viewModel.moreDetailurl;
            webVC.title = @"团购劵图文详情";
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        return cell;
    }
    else if (indexPath.section == 3) {
        CouponInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponInformationCell"];
        [self configureInformationCell:cell atIndexPath:indexPath];
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            CouponCommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentTitleCell className]];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@人评价", self.viewModel.totalComment];
            return cell;
        }
        else {
            CouponCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCommentCell"];
            [self configureCommentCell:cell atIndexPath:indexPath];
            return cell;
        }
    }

}

- (void)configureCommentCell:(CouponCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CouponCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row - 1];
    cell.name.text = model.userName;
    cell.time.text = [NSString convertTime:model.time];
    cell.content.text = model.content;
    cell.imageArray = model.pictureArray;
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
    cell.starView.value = [model.score floatValue];
    cell.starView.enabled = NO;
    cell.starView.alpha = 1.0;
    [cell.collectionView reloadData];
}

- (void)configureInformationCell:(CouponInformationCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.validity.text = [NSString stringWithFormat:@"%@至%@", [NSString convertTime:self.couponModel.startTime] , [NSString convertTime:self.couponModel.endTime]];
    cell.useRuleLabel.text = self.viewModel.useRule;
    cell.tipsLabel.text = self.viewModel.tips;
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
        return [tableView fd_heightForCellWithIdentifier:[CouponInformationCell className] configuration:^(CouponInformationCell *cell) {
            @strongify(self)
            [self configureInformationCell:cell atIndexPath:indexPath];
        }];
    }
    else {
        if (indexPath.row == 0) {
            return 44;
        }
        else {
            CouponCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row - 1];
            NSInteger dynamic = 0;
            if (model.pictureArray.count > 6) {
                dynamic = 130;
            }
            else if (model.pictureArray.count > 0) {
                dynamic = 64;
            }
            return [tableView fd_heightForCellWithIdentifier:@"CouponCommentCell" configuration:^(CouponCommentCell *cell) {
                @strongify(self)
                [self configureCommentCell:cell atIndexPath:indexPath];
            }] + dynamic;
        }
    }
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.currentPage != self.viewModel.totalPage && indexPath.row == self.viewModel.commentArray.count - 1) {
        [self.viewModel loadMoreCommentWithCouponID:self.couponModel.identifier page:[NSNumber numberWithInteger:++self.viewModel.currentPage]];
    }
    
}

#pragma mark -prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CommitOrder"]) {
        CommitOrderViewController *commitVC = segue.destinationViewController;
        commitVC.couponModel = self.couponModel;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    if ([accountDao isLogin]) {
        return YES;
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录国贸账号";
        [hud hide:YES afterDelay:1.5f];
        return NO;
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
