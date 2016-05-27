//
//  CouponRefundViewController.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponRefundViewController.h"
#import "CouponRefundViewModel.h"
#import "CouponOrderTableViewCell.h"
#import "CouponOrderModel.h"
#import "MBProgressHUD.h"
#import "NSString+Expand.h"
#import "OrderDetailViewController.h"


@interface CouponRefundViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CouponRefundViewModel *viewModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation CouponRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self bindViewModel];
    
    [self.viewModel fetchRefundData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"couponOrder"];
    
    [self configureTableView];
    
}

- (void)bindViewModel {
    
    self.viewModel = [[CouponRefundViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.refundSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        [self.tableView reloadData];
    }];
    
    [self.viewModel.refundFailureObject subscribeNext:^(id x) {
        
        
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        
        @strongify(self)
        
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
        
    }];
    
}

- (void)configureTableView {
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView setRowHeight:165];
    
    
}

- (void)refreshTableView {
    
    [self.viewModel refreshData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel cacheData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.refundArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponOrderModel *model = [self.viewModel.refundArray objectAtIndex:indexPath.row];
    CouponOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponOrder"];
    cell.titleLabel.text = model.storeName;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    cell.timeLabel.text = [NSString convertTime:model.endTime];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", model.count];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.totalPrice floatValue] / 100];
    
    cell.statusLabel.text = @"已退款";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CouponOrderModel *model = [self.viewModel.refundArray objectAtIndex:indexPath.row];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    orderDetailVC.orderModel = model;
    //声明状态为退款
    orderDetailVC.state = @3;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
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
