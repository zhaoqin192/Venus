//
//  GMMeTakeAwayViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayViewController.h"
#import "XFSegementView.h"
#import "GMMeTakeAwayCell.h"
#import "NetworkFetcher+FoodOrder.h"
#import "FoodOrderManager.h"
#import "TakeAwayOrder.h"
#import "GMMeTakeAwayDetailViewController.h"

@interface GMMeTakeAwayViewController () <UITableViewDelegate, UITableViewDataSource, TouchLabelDelegate>

@property (strong, nonatomic) XFSegementView *segementView;
@property (assign, nonatomic) NSInteger currentSemementIndex;

@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FoodOrderManager *orderManager;

@end

@implementation GMMeTakeAwayViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    [self.view addSubview:[self segementView]];
}

- (void)viewWillAppear:(BOOL)animated {

    [self.orderManager updateOrderSucceed:^{
        [self.tableView reloadData];
    } failed:^(NSString *error) {
        NSLog(@"网络错误，错误是%@",error);
    }];
    
    self.navigationItem.title = @"订单";
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
   [self.rdv_tabBarController setTabBarHidden:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderManager.orderArray.count != 0) {
        if (self.currentSemementIndex == 0) {
            return self.orderManager.orderArray.count;
        } else if (self.currentSemementIndex == 1) {
            if (self.orderManager.waitingEvalutationOrderArray) {
                return self.orderManager.waitingEvalutationOrderArray.count;
            } else {
                return 0;
            }
        } else {
            if (self.orderManager.refundOrderArray) {
                return self.orderManager.refundOrderArray.count;
            } else {
                return 0;
            }
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMMeTakeAwayCell *cell = [GMMeTakeAwayCell cellForTableView:tableView];
    if  (self.currentSemementIndex == 0) {
        if (self.orderManager.orderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.orderArray[indexPath.row];
        }
    } else if (self.currentSemementIndex == 1){
        if (self.orderManager.waitingEvalutationOrderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.waitingEvalutationOrderArray[indexPath.row];
        }
    } else {
        if (self.orderManager.refundOrderArray.count != 0) {
            cell.order = (TakeAwayOrder *)self.orderManager.refundOrderArray[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GMMeTakeAwayDetailViewController *vc = [[GMMeTakeAwayDetailViewController alloc] init];
    vc.orderID = [(TakeAwayOrder *)self.orderManager.orderArray[indexPath.row] orderId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TouchLabelDelegate
- (void)touchLabelWithIndex:(NSInteger)index {
    self.currentSemementIndex = index;
    [self.tableView reloadData];
}

#pragma mark - private methods

#pragma mark - event response
- (void)searchButtonClicked:(id)sender {
    NSLog(@"搜索按钮点击");
    
}

#pragma mark - getters and setters
- (XFSegementView *)segementView {
    if (!_segementView) {
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
        _segementView.titleArray = @[@"全部",@"待评价",@"退款"];
        _segementView.backgroundColor = [UIColor whiteColor];
        _segementView.titleColor = [UIColor lightGrayColor];
        _segementView.haveRightLine = YES;
        _segementView.separateColor = [UIColor grayColor];
        [_segementView.scrollLine setBackgroundColor:GMBrownColor];
        _segementView.titleSelectedColor = GMBrownColor;
        _segementView.touchDelegate = self;
        [_segementView selectLabelWithIndex:0];
    }
    return _segementView;
}

- (UIBarButtonItem *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked:)];
    }
    return _searchButton;
}

- (FoodOrderManager *)orderManager {
    if (!_orderManager) {
        _orderManager = [FoodOrderManager sharedInstance];
    }
    return _orderManager;
}

@end
