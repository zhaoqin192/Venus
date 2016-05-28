//
//  CouponCommentDetailViewController.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentDetailViewController.h"
#import "CouponCommentDetailViewModel.h"
#import "CouponOrderModel.h"
#import "MBProgressHUD.h"
#import "CouponCommentDetailHeadCell.h"
#import "CouponCommentMessageCell.h"
#import "CouponCommentMessageSectionCell.h"

@interface CouponCommentDetailViewController ()<UITabBarDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) CouponCommentDetailViewModel *viewModel;

@end

@implementation CouponCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self bindViewModel];
    
    [self configureTableView];
    
    [self onClickEvent];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)bindViewModel {
    
    self.viewModel = [[CouponCommentDetailViewModel alloc] init];
    @weakify(self)
    [self.viewModel.commentSuccessObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
        hud.completionBlock = ^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        };
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)onClickEvent {
    
    @weakify(self)
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel sendCommentWithOrderID:self.orderModel.orderID couponID:self.orderModel.couponID storeID:self.orderModel.storeID];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"starValueChanged" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
       
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        self.viewModel.score = userInfo[@"value"];
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"contentChanged" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        self.viewModel.commentString = userInfo[@"content"];
        
    }];
    
}


- (void)configureTableView {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    [self.tableView registerNib:[UINib nibWithNibName:[CouponCommentDetailHeadCell className] bundle: nil] forCellReuseIdentifier:[CouponCommentDetailHeadCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[CouponCommentMessageCell className] bundle:nil] forCellReuseIdentifier:[CouponCommentMessageCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[CouponCommentMessageSectionCell className] bundle:nil] forCellReuseIdentifier:[CouponCommentMessageSectionCell className]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 164;
    }
    else {
        return 208;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 30;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;

}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CouponCommentDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentDetailHeadCell className]];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.orderModel.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
        
        cell.titleLabel.text = self.orderModel.storeName;
        cell.describeLabel.text = self.orderModel.resume;
        
        return cell;
    }
    else {
        
        CouponCommentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentMessageCell className]];
        
        return cell;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        CouponCommentMessageSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentMessageSectionCell className]];
        return cell;
    }
    
    return nil;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
