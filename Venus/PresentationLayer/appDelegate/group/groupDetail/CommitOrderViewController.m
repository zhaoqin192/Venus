//
//  CommitOrderViewController.m
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CommitOrderViewController.h"
#import "CouponModel.h"
#import "CommitCountCell.h"
#import "CommitPayCell.h"
#import "CommitPriceCell.h"
#import "CommitOrderViewModel.h"

@interface CommitOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (nonatomic, strong) CommitOrderViewModel *viewModel;

@end

@implementation CommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTableView];
    
    [self bindViewModel];
    
    [self onCliceEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}

- (void)bindViewModel {
    
    self.viewModel = [[CommitOrderViewModel alloc] init];
    
    RAC(self.commitButton, enabled) = [self.viewModel commitButtonIsValid];
    
    @weakify(self)
    [RACObserve(self.commitButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x isEqual: @(1)]) {
            [self.commitButton setAlpha:1];
        }
        else {
            [self.commitButton setAlpha:0.5];
        }
        
    }];
    
    [self.viewModel.countObject subscribeNext:^(id x) {
        @strongify(self)

        [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    [self.viewModel initPrice:self.couponModel.price];
    
}

- (void)onCliceEvent {
    
    @weakify(self)
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
       
        @strongify(self)
        [self.viewModel createOrderWithCouponID:self.couponModel.identifier storeID:self.couponModel.storeID num:[NSNumber numberWithInteger:self.viewModel.countNumber]];
        
    }];
    
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return @"支付方式";
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.couponModel.abstract;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }
        else if (indexPath.row == 1) {
            @weakify(self)
            CommitCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommitCountCell"];
            @weakify(cell)
            [[cell.subtractionButton rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                @strongify(self)
                @strongify(cell)
                [self.viewModel subtractCount];
                cell.count.text = [NSString stringWithFormat:@"%ld", self.viewModel.countNumber];
                self.totalPrice.text = [NSString stringWithFormat:@"还需支付￥%ld", self.viewModel.totalPrice];
            }];
            
            [[cell.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                @strongify(self)
                @strongify(cell)
                [self.viewModel addCount];
                cell.count.text = [NSString stringWithFormat:@"%ld", self.viewModel.countNumber];
                self.totalPrice.text = [NSString stringWithFormat:@"还需支付￥%ld", self.viewModel.totalPrice];
            }];
            cell.count.text = [NSString stringWithFormat:@"%ld", self.viewModel.countNumber];
            return cell;
        }
        else {
            CommitPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommitPriceCell"];
            cell.priceLabel.text = [NSString stringWithFormat:@"%ld", self.viewModel.totalPrice];
            return cell;
        }
    }
    
    else {
        CommitPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommitPayCell"];
        if (indexPath.row == 0) {
            cell.name.text = @"支付宝";
            @weakify(self)
            @weakify(cell)
            [[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                @strongify(self)
                @strongify(cell)
                if (self.viewModel.isSelected && self.viewModel.selectPay == indexPath.row) {
                    [cell.selectButton setImage:[UIImage imageNamed:@"icon_pay_radio_unselected"] forState:UIControlStateNormal];
                    self.viewModel.isSelected = NO;
                }
                else {
                    [cell.selectButton setImage:[UIImage imageNamed:@"icon_cycle_select"] forState:UIControlStateNormal];
                    self.viewModel.isSelected = YES;
                    self.viewModel.selectPay = indexPath.row;
                }
            }];
        }
        return cell;
        
    }
    
    return nil;
}


@end
