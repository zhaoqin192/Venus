//
//  OrderDetailViewController.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailViewModel.h"
#import "CouponOrderModel.h"
#import "OrderDetailInfoCell.h"
#import "OrderCouponIDCell.h"
#import "OrderDescribeCell.h"
#import "OrderMessageCell.h"
#import "NSString+Expand.h"
#import "StockModel.h"
#import "MBProgressHUD.h"
#import "RefundViewController.h"
#import "CouponCommentDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OrderDetailViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单详情";
    
    [self configureTable];
    
    [self bindViewModel];
    
    
    [self.viewModel fetchDetailDataWithOrderID:self.orderModel.orderID];
    
    if ([self.state isEqualToNumber:@1]) {
        [self.refundButton setTitle:@"付款" forState:UIControlStateNormal];
    }
    else if ([self.state isEqualToNumber:@2]) {
        [self.refundButton setTitle:@"评价" forState:UIControlStateNormal];
    }
    else if ([self.state isEqualToNumber:@3]) {
        [self.bottomView removeFromSuperview];
    }
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
    
    self.viewModel = [[OrderDetailViewModel alloc] init];
    
    self.viewModel.couponModel = self.orderModel;
    
    @weakify(self)
    [self.viewModel.detailSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
        
    }];
    [self.viewModel.detailFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [self.viewModel.paymentFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)onClickEvent {
    
    @weakify(self)
    [[self.refundButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if ([self.state isEqualToNumber:@0]) {
            
            
//            UIStoryboard *group = [UIStoryboard storyboardWithName:@"group" bundle:nil];
//            GroupViewController *vc = (GroupViewController *)[group instantiateViewControllerWithIdentifier:@"group"];
//            [self.navigationController pushViewController:vc animated:YES];
            
            UIStoryboard *refund = [UIStoryboard storyboardWithName:@"refund" bundle:nil];
            RefundViewController *refundVC = (RefundViewController *)[refund instantiateViewControllerWithIdentifier:@"refund"];
            
//            RefundViewController *refundVC = [[RefundViewController alloc] initWithNibName:@"RefundViewController" bundle:nil];
            refundVC.unitPrice = self.viewModel.price;
            refundVC.codeArray = self.viewModel.codeArray;
            refundVC.orderModel = self.orderModel;
            [self.navigationController pushViewController:refundVC animated:YES];
            
        }
        else if ([self.state isEqualToNumber:@1]) {
            
            [self.viewModel paymentWithOrderID:self.orderModel.orderID];
            
        }
        else if ([self.state isEqualToNumber:@2]) {
            
            CouponCommentDetailViewController *commentVC = [[CouponCommentDetailViewController alloc] initWithNibName:@"CouponCommentDetailViewController" bundle:nil];
            commentVC.orderModel = self.orderModel;
            [self.navigationController pushViewController:commentVC animated:YES];
            
        }
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"PayFailure" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id x) {
         
         @strongify(self)
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.mode = MBProgressHUDModeText;
         hud.labelText = @"支付失败";
         [hud hide:YES afterDelay:1.5f];
         
     }];
    
}


- (void)configureTable {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailInfoCell" bundle:nil] forCellReuseIdentifier:[OrderDetailInfoCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCouponIDCell" bundle:nil] forCellReuseIdentifier:[OrderCouponIDCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDescribeCell className] bundle:nil] forCellReuseIdentifier:[OrderDescribeCell className]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderMessageCell className] bundle:nil] forCellReuseIdentifier:[OrderMessageCell className]];
    
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 120;
        }
        return 44;
    }
    else if (indexPath.section == 1) {
        return 89;
    }
    else {
        return 264;
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


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.viewModel.codeArray.count + 1;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailInfoCell className]];
            cell.titleLabel.text = self.orderModel.storeName;
            
            cell.asPriceLabel.text = self.orderModel.resume;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.viewModel.price floatValue] / 100];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:self.orderModel.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
            return cell;
        }
        else {
            OrderCouponIDCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCouponIDCell className]];
            
            StockModel *model = [self.viewModel.codeArray objectAtIndex:indexPath.row - 1];
            cell.codeLabel.text = model.code;
            
            if ([self.state isEqualToNumber:@2]) {
                cell.statusLabel.text = @"待评价";
            }
            else if ([self.state isEqualToNumber:@3]) {
                cell.statusLabel.text = @"退款成功";
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        
        OrderDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderDescribeCell className]];
        cell.describeLabel.text = self.viewModel.describe;
        return cell;
        
    }
    else {
        
        OrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderMessageCell className]];
        cell.orderIDLabel.text = self.orderModel.orderID;
        cell.creatTimeLabel.text = [NSString convertTime:self.orderModel.creatTime];
        cell.phoneLabel.text = self.viewModel.phone;
        cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.codeArray.count];
        
        if ([self.state isEqualToNumber:@1]) {
            cell.payMethodLabel.text = @"暂无";
        }
        
        return cell;
        
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
