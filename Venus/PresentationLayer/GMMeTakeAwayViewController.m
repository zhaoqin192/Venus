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

@interface GMMeTakeAwayViewController () <UITableViewDelegate, UITableViewDataSource, TouchLabelDelegate>

@property (strong, nonatomic) XFSegementView *segementView;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [NetworkFetcher foodFetcherUserFoodOrderOnPage:0 success:^(NSDictionary *response){
        NSLog(@"获取成功");
    } failure:^(NSString *error) {
        NSLog(@"产生错误%@",error);
    }];
    self.navigationItem.title = @"订单";
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
   [self.rdv_tabBarController setTabBarHidden:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMMeTakeAwayCell *cell = [GMMeTakeAwayCell cellForTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}

#pragma mark - TouchLabelDelegate
- (void)touchLabelWithIndex:(NSInteger)index {
    NSLog(@"现在的index是%li",(long)index);
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

@end
