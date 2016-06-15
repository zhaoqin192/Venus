//
//  CouponUseViewController.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponUseViewController.h"
#import "CouponUseViewModel.h"
#import "CouponOrderTableViewCell.h"
#import "CouponOrderModel.h"
#import "MBProgressHUD.h"
#import "NSString+Expand.h"
#import "OrderDetailViewController.h"


@interface CouponUseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CouponUseViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation CouponUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self bindViewModel];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"couponOrder"];
    
    [self configureTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel fetchUseData];
    [MobClick beginLogPageView:@"CouponUseViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel cacheData];
    [MobClick endLogPageView:@"CouponUseViewController"];
}


- (void)bindViewModel {
    
    self.viewModel = [[CouponUseViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.useSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        [self.tableView reloadData];
    }];
    
    [self.viewModel.useFailureObject subscribeNext:^(id x) {
        
        
        
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



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.useArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponOrderModel *model = [self.viewModel.useArray objectAtIndex:indexPath.row];
    CouponOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponOrder"];
    cell.titleLabel.text = model.storeName;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    cell.timeLabel.text = [NSString convertTime:model.endTime];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", model.count];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.totalPrice floatValue] / 100];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CouponOrderModel *model = [self.viewModel.useArray objectAtIndex:indexPath.row];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    orderDetailVC.orderModel = model;
    //声明状态为待使用
    orderDetailVC.state = @0;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
