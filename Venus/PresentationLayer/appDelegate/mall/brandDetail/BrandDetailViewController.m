//
//  BrandDetailViewController.m
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "BrandDetailViewModel.h"
#import "BrandDetailCommentCell.h"
#import "BrandDetailSectionHeadCell.h"
#import "BrandDetailCommentModel.h"
#import "NSString+Expand.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "MBProgressHUD.h"
#import "BrandDetailSectionHeadCell.h"
#import "BrandDetailHeadViewCell.h"
#import "BrandKindTableViewCell.h"
#import "KindDetailViewController.h"
#import "MerchandiseModel.h"
#import "BrandCommentView.h"
#import "BrandDetailCell.h"
#import "BrandDetailShowCell.h"
#import "BrandDetailSectionHeadView.h"

typedef NS_ENUM(NSInteger, BrandState) {
    //三种tab选择状态
    BrandDetail,
    BrandKind,
    BrandComment,
};

@interface BrandDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BrandState selectTab;
@property (nonatomic, strong) BrandDetailViewModel *viewModel;
@property (nonatomic, strong) BrandCommentView *commentView;
@property (nonatomic, strong) NSNumber *webViewHeight;
@property (nonatomic, assign) BOOL webViewActive;
@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"品牌详情";
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureTableView];
    
    self.selectTab = BrandDetail;
    
    [self bindViewModel];
    
    [self.viewModel fetchDetailWithStoreID:self.storeID];
    [self.viewModel fetchAllKindsWithStoreID:self.storeID page:self.viewModel.kindCurrentPage];
    [self.viewModel fetchCommentWithStoreID:self.storeID page:self.viewModel.commentCurrentPage];

    
    [self configureCommentView];
    
    self.webViewHeight = @93.5;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)bindViewModel {

    self.viewModel = [[BrandDetailViewModel alloc] init];
    @weakify(self)
    [self.viewModel.commentSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectTab == BrandComment) {
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            self.commentView.inputTextField.text = nil;
        }
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.commentLoadMoreObject subscribeNext:^(NSNumber *count) {
        if (self.selectTab == BrandComment) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            @strongify(self)
            NSInteger baseCount = self.viewModel.commentArray.count - [count integerValue];
            for (int i = 0; i < [count integerValue]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:baseCount + i inSection:1];
                [indexPaths addObject:indexPath];
            }
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    [self.viewModel.detailSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.viewModel.detailFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.kindSuccessObject subscribeNext:^(id x) {
    }];
    
    [self.viewModel.kindFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadViewDetail object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        if (_selectTab == BrandDetail) {
            return;
        }
        else if (_selectTab == BrandKind) {
            self.selectTab = BrandDetail;
            NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
            NSInteger count = 0;
            if (self.viewModel.kindArray.count % 2 == 0) {
                count = self.viewModel.kindArray.count / 2;
            }
            else {
                count = self.viewModel.kindArray.count / 2 + 1;
            }
            if (count < 2) {
                if (count == 0) {
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [insertIndexPaths addObject:indexPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
                else if (count == 1) {
                    [self.tableView insertRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [insertIndexPaths addObject:indexPath];
                    }
                    [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else {
                for (int i = 2; i < count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [deleteIndexPaths addObject:indexPath];
                }
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                for (int i = 0; i < 2; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if (_selectTab == BrandComment) {
            [self.commentView removeFromSuperview];
            self.selectTab = BrandDetail;
            NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
            NSInteger count = self.viewModel.commentArray.count;
            if (count < 2) {
                if (count == 0) {
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [insertIndexPaths addObject:indexPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
                else if (count == 1) {
                    [self.tableView insertRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [insertIndexPaths addObject:indexPath];
                    }
                    [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else {
                for (int i = 2; i < count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [deleteIndexPaths addObject:indexPath];
                }
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                for (int i = 0; i < 2; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
        }

    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadViewKind object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        if (_selectTab == BrandKind) {
            return;
        }
        else if (_selectTab == BrandDetail) {
            self.selectTab = BrandKind;
            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
            NSInteger count = 0;
            if (self.viewModel.kindArray.count % 2 == 0) {
                count = self.viewModel.kindArray.count / 2;
            }
            else {
                count = self.viewModel.kindArray.count / 2 + 1;
            }
            if (count < 2) {
                NSMutableArray *deleteIndexPahts = [[NSMutableArray alloc] init];
                if (count == 0) {
                    for (int i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [deleteIndexPahts addObject:indexPath];
                    }
                    [self.tableView deleteRowsAtIndexPaths:deleteIndexPahts withRowAnimation:UITableViewRowAnimationNone];
                }
                else if (count == 1) {
                    [self.tableView deleteRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else {
                for (int i = 2; i < count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                for (int i = 0; i < 2; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths insertObject:indexPath atIndex:0];
                }
                [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if (_selectTab == BrandComment) {
            [self.commentView removeFromSuperview];
            self.selectTab = BrandKind;
            NSInteger kindCount = 0;
            if (self.viewModel.kindArray.count % 2 == 0) {
                kindCount = self.viewModel.kindArray.count / 2;
            }
            else {
                kindCount = self.viewModel.kindArray.count / 2 + 1;
            }
            NSInteger commentCount = self.viewModel.commentArray.count;
            if (kindCount < commentCount) {
                if (kindCount == 0) {
                    NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
                    for (NSInteger i = kindCount; i < commentCount; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [deleteIndexPaths addObject:indexPath];
                    }
                    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
                else {
                    NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
                    for (NSInteger i = kindCount; i < commentCount; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [deleteIndexPaths addObject:indexPath];
                    }
                    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                    NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0; i < kindCount; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [reloadIndexPaths addObject:indexPath];
                    }
                    [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else if (kindCount == commentCount) {
                NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                for (int i = 0; i < kindCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [reloadIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            else if (kindCount > commentCount) {
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = commentCount; i < kindCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < kindCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [reloadIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadViewComment object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        if (_selectTab == BrandComment) {
            return;
        }
        else if (_selectTab == BrandKind) {
            self.selectTab = BrandComment;
            NSInteger kindCount = 0;
            if (self.viewModel.kindArray.count % 2 == 0) {
                kindCount = self.viewModel.kindArray.count / 2;
            }
            else {
                kindCount = self.viewModel.kindArray.count / 2 + 1;
            }
            NSInteger commentCount = self.viewModel.commentArray.count;
            if (kindCount < commentCount) {
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = kindCount; i < commentCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < commentCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [reloadIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            else if (kindCount == commentCount) {
                NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < commentCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [reloadIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            else if (kindCount > commentCount) {
                NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = commentCount; i < kindCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [deleteIndexPaths addObject:indexPath];
                }
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < commentCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [reloadIndexPaths addObject:indexPath];
                }
                [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.view addSubview:self.commentView];
        }
        else if (_selectTab == BrandDetail) {
            self.selectTab = BrandComment;
            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
            NSInteger count = self.viewModel.commentArray.count;
            if (count < 2) {
                if (count == 0) {
                    NSMutableArray *deleteIndexPahts = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0; i < 2; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                        [deleteIndexPahts addObject:indexPath];
                    }
                    [self.tableView deleteRowsAtIndexPaths:deleteIndexPahts withRowAnimation:UITableViewRowAnimationNone];
                }
                else if (count == 1) {
                    [self.tableView deleteRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else {
                for (int i = 2; i < count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths addObject:indexPath];
                }
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                for (int i = 0; i < 2; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                    [insertIndexPaths insertObject:indexPath atIndex:0];
                }
                [self.tableView reloadRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.view addSubview:self.commentView];
        }

    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showDetail" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        KindDetailViewController *kindDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KindDetailViewController"];
        MerchandiseModel *model = [[MerchandiseModel alloc] init];
        model.identifier = userInfo[@"identifier"];
        kindDetailVC.merchandiseModel = model;
        [self.navigationController pushViewController:kindDetailVC animated:YES];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailWebViewHeight object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         NSDictionary *userInfo = notification.userInfo;
         self.webViewHeight = userInfo[@"height"];
         if (!self.webViewActive) {
             [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
             self.webViewActive = YES;
         }
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)configureCommentView {
    
    self.commentView = [[[NSBundle mainBundle] loadNibNamed:@"BrandCommentView" owner:self options:nil] firstObject];
    self.commentView.frame = CGRectMake(0, kScreenHeight - 45 - 64, kScreenWidth, 45);

    @weakify(self)
    [[self.commentView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (self.commentView.inputTextField.text.length > 0) {
            [self.viewModel sendCommentWithStoreID:self.storeID cotent:self.commentView.inputTextField.text];
            [self.commentView.inputTextField resignFirstResponder];
        }
        else {
            @strongify(self)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"评论不能为空";
            [hud hide:YES afterDelay:1.5f];
        }
    }];
}

- (void)configureTableView {
    //取消多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}

#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        switch (self.selectTab) {
            case BrandDetail:
                return 2;
            case BrandKind:
                if (self.viewModel.kindArray.count % 2 == 0) {
                    return self.viewModel.kindArray.count / 2;
                }
                else {
                    return self.viewModel.kindArray.count / 2 + 1;
                }
            case BrandComment:
                return self.viewModel.commentArray.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BrandDetailHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandDetailHeadViewCell className]];
        [self configureHeadCell:cell atIndexPath:indexPath];
        return cell;
    }
    else {
        switch (self.selectTab) {
            case BrandDetail:{
                if (indexPath.row == 0) {
                    BrandDetailShowCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandDetailShowCellIdentifier];
                    [cell showArrayLoad:self.viewModel.showArray];
                    return cell;
                }
                else if (indexPath.row == 1) {
                    BrandDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandDetailCellIdentifier];
                    if (self.viewModel.detailURL) {
                        [cell loadURL:[@"http://www.chinaworldstyle.com" stringByAppendingString:self.viewModel.detailURL]];
                    }
                    return cell;
                }
            }
            case BrandKind: {
                BrandKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandKindTableViewCell className]];
                if (indexPath.row * 2 + 1 < self.viewModel.kindArray.count) {
                    [cell insertLeftModel:[self.viewModel.kindArray objectAtIndex:indexPath.row * 2] rightModel:[self.viewModel.kindArray objectAtIndex:indexPath.row * 2 + 1]];
                }
                else {
                    [cell insertLeftModel:[self.viewModel.kindArray objectAtIndex:indexPath.row * 2]];
                }
                
                return cell;
            }
            case BrandComment: {
                BrandDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandDetailCommentCell className]];
                [self configureCommentCell:cell atIndexPath:indexPath];
                return cell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectTab == BrandComment && self.viewModel.commentCurrentPage != self.viewModel.commentTotalPage && indexPath.row == self.viewModel.commentArray.count - 1) {
        [self.viewModel loadMoreCommentWithStoreID:self.storeID page:++self.viewModel.commentCurrentPage];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:[BrandDetailHeadViewCell className] configuration:^(BrandDetailHeadViewCell *cell) {
            [self configureHeadCell:cell atIndexPath:indexPath];
        }];
    }
    else {
        switch (self.selectTab) {
            case BrandDetail:
                if (indexPath.row == 0) {
                    return 156;
                }
                else if (indexPath.row == 1) {
                    return [self.webViewHeight floatValue] + 30;
                }
            case BrandKind:
                return 270;
            case BrandComment:
                return [tableView fd_heightForCellWithIdentifier:[BrandDetailCommentCell className] configuration:^(BrandDetailCommentCell *cell) {
                    [self configureCommentCell:cell atIndexPath:indexPath];
                }];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {        
        BrandDetailSectionHeadView *cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandDetailSectionHeadView" owner:self options:nil] firstObject];;
        
        switch (self.selectTab) {
            case BrandDetail:
                [cell detailSelected];
                break;
            case BrandKind:
                [cell kindSelected];
                break;
            case BrandComment:
                [cell commentSelected];
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        return 75;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    else {
        return CGFLOAT_MIN;
    }
}

- (void)configureHeadCell:(BrandDetailHeadViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell.image sd_setImageWithURL:[NSURL URLWithString:self.viewModel.logoURL] placeholderImage:[UIImage imageNamed:@"default"]];
    cell.nameLabel.text = self.viewModel.storeName;
    cell.addressLabel.text = self.viewModel.storeAddress;
    cell.describeLabel.text = self.viewModel.describe;
}

- (void)configureCommentCell:(BrandDetailCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BrandDetailCommentModel *model = [self.viewModel.commentArray objectAtIndex:indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
    cell.nameLabel.text = model.name;
    cell.timeLabel.text = [NSString convertTime:model.time];
    cell.contentLabel.text = model.content;
}

//获取键盘的高度
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.frame = CGRectMake(0, self.tableView.frame.size.height - 45 -height, kScreenWidth, 45);
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.frame = CGRectMake(0, self.tableView.frame.size.height - 45, kScreenWidth, 45);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
