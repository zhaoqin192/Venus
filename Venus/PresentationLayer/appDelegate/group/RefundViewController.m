//
//  RefundViewController.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "RefundViewController.h"
#import "RefundCodeCell.h"
#import "RefundPriceCell.h"
#import "RefundReasonCell.h"
#import "RefundReasonHeadCell.h"
#import "RefundViewModel.h"
#import "StockModel.h"
#import "MBProgressHUD.h"
#import "CouponOrderModel.h"
#import "PersonalCouponViewController.h"

@interface RefundViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) RefundViewModel *viewModel;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"申请退款";
    
    [self configureTable];
    
    [self bindViewModel];
    
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
    
    self.viewModel = [[RefundViewModel alloc] init];
    
    @weakify(self)
    RAC(self.commitButton, enabled) = [self.viewModel isValid];
    
    [RACObserve(self.commitButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x isEqual:@(1)]) {
            [self.commitButton setAlpha:1];
        }
        else {
            [self.commitButton setAlpha:0.5];
        }
    }];
    
    [self.viewModel.refundSuccessObject subscribeNext:^(id x) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请成功" message:@"退款预计一周内返回支付宝" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            @strongify(self)
            
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for (UIViewController *viewController in allViewControllers) {
                
                if ([viewController isKindOfClass:[PersonalCouponViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                }
                
            }
            
        }];
        
        [alertController addAction:confirmAction];
        @strongify(self)
        [self presentViewController:alertController animated:YES completion:nil];

 
    }];
    
    [self.viewModel.refundFailureObject subscribeNext:^(NSString *message) {
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
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CodeAdd" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        self.viewModel.count++;
        [self.viewModel.selectCode addObject:[NSNumber numberWithString:userInfo[@"code"]]];
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CodeSubtraction" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        self.viewModel.count--;
        [self.viewModel.selectCode removeObject:[NSNumber numberWithString:userInfo[@"code"]]];
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"selectReason" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        [self.viewModel.selectReason addObject:userInfo[@"reason"]];
        self.viewModel.reasonCount++;
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"cancelReason" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        [self.viewModel.selectReason removeObject:userInfo[@"reason"]];
        self.viewModel.reasonCount--;
        
    }];
    
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel commitRefundWithOrderID:self.orderModel.orderID couponID:self.orderModel.couponID codeArray:self.viewModel.selectCode];
    }];
}

- (void)configureTable {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    [self.tableView registerNib:[UINib nibWithNibName:[RefundCodeCell className] bundle:nil] forCellReuseIdentifier:[RefundCodeCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[RefundPriceCell className] bundle:nil] forCellReuseIdentifier:[RefundPriceCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[RefundReasonHeadCell className] bundle:nil] forCellReuseIdentifier:[RefundReasonHeadCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[RefundReasonCell className] bundle:nil] forCellReuseIdentifier:[RefundReasonCell className]];
    
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 88;
    }
    else {
        return 44;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return CGFLOAT_MIN;
    }
    else {
        return 10;
    }
    
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.codeArray.count;
    }
    else if (section == 1) {
        return 1;
    }
    else {
        return self.viewModel.reasonArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RefundCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:[RefundCodeCell className]];
        StockModel *model = [self.codeArray objectAtIndex:indexPath.row];
        cell.codeLabel.text = model.code;
        cell.codeIdentifier = model.identifier;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        RefundPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:[RefundPriceCell className]];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.unitPrice floatValue] * self.viewModel.count / 100];
        return cell;
    }
    else {
        
        if (indexPath.row == 0) {
            RefundReasonHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[RefundReasonHeadCell className]];
            return cell;
        }
        else {
            RefundReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:[RefundReasonCell className]];
            cell.reasonLabel.text = [self.viewModel.reasonArray objectAtIndex:indexPath.row - 1];
            return cell;
        }
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
