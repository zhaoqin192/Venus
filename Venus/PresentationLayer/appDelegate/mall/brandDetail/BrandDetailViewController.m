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
@property (nonatomic, assign) BOOL commentActive;
@property (nonatomic, assign) BOOL kindActive;
@property (nonatomic, strong) BrandCommentView *commentView;
@property (nonatomic, strong) NSNumber *webViewHeight;
@property (nonatomic, assign) BOOL webViewActive;
@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"品牌详情";
    
    [self configureTableView];
    
    self.selectTab = BrandDetail;
    
    [self bindViewModel];
    
    [self.viewModel fetchDetailWithStoreID:self.storeID];
    
    [self configureCommentView];
    
    self.webViewHeight = @88;
    
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
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        self.commentView.inputTextField.text = nil;
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.commentLoadMoreObject subscribeNext:^(NSNumber *count) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        @strongify(self)
        NSInteger baseCount = self.viewModel.commentArray.count - [count integerValue];
        for (int i = 0; i < [count integerValue]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:baseCount + i inSection:1];
            [indexPaths addObject:indexPath];
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.viewModel.detailSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.viewModel.detailFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.kindSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
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
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadCellDetail object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        self.selectTab = BrandDetail;
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        [self.commentView removeFromSuperview];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadCellKind object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        self.selectTab = BrandKind;
        if (!self.kindActive) {
            [self.viewModel fetchAllKindsWithStoreID:self.storeID page:self.viewModel.kindCurrentPage];
            self.kindActive = YES;
        }
        else {
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.commentView removeFromSuperview];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:BrandDetailSectionHeadCellComment object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
        @strongify(self)
        self.selectTab = BrandComment;
        if (!self.commentActive) {
            [self.viewModel fetchCommentWithStoreID:self.storeID page:self.viewModel.commentCurrentPage];
            self.commentActive = YES;
        }
        else {
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.view addSubview:self.commentView];
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
    self.commentView.frame = CGRectMake(0, self.tableView.frame.size.height - 45, kScreenWidth, 45);

    @weakify(self)
    [[self.commentView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel sendCommentWithStoreID:self.storeID cotent:self.commentView.inputTextField.text];
        [self.commentView.inputTextField resignFirstResponder];
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
                return 1;
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
                BrandDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandDetailCellIdentifier];
                if (self.viewModel.detailURL) {
//                    [cell loadURL:[@"http://www.chinaworldstyle.com" stringByAppendingString:self.viewModel.detailURL]];
                    [cell loadURL:@"http://www.chinaworldstyle.com/bazaar/mobile/imageText?type=brandInfo&id=100016"];
                }
                return cell;
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
    if (self.viewModel.commentCurrentPage != self.viewModel.commentTotalPage && indexPath.row == self.viewModel.commentArray.count - 1) {
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
                return [self.webViewHeight floatValue];
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
        BrandDetailSectionHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandDetailSectionHeadCell className]];
        UIView *sectionHeadView = [[UIView alloc] initWithFrame:[cell frame]];
        [sectionHeadView addSubview:cell];
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
        return sectionHeadView;
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
