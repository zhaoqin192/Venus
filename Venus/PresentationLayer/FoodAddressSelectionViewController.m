//
//  FoodAddressSelectionViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddressSelectionViewController.h"
#import "FoodAddressManager.h"
#import "FoodAddress.h"
#import "FoodShowAddressCell.h"
#import "FoodAddressEditViewController.h"
#import "FoodOrderAddAddressViewController.h"
#import "NetworkFetcher+FoodAddress.h"

@interface FoodAddressSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FoodAddressManager *foodAddressManager;

@end

@implementation FoodAddressSelectionViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FoodAddressSelectionViewController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"选择地址";
    [NetworkFetcher foodFetcherUserFoodAddresWithRestaurantID:self.restaurantID success:^{
        if (self.selectedIndex >= self.foodAddressManager.foodAddressArray.count) {
            self.selectedIndex = 0;
        }
        [self.tableView reloadData];
    } failure:^(NSString *error){
        NSLog(@"获取最新地址失败，error是%@",error);
    }];
    [MobClick beginLogPageView:@"FoodAddressSelectionViewController"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return self.foodAddressManager.foodAddressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodShowAddressCell *cell = [FoodShowAddressCell cellForTableView:tableView];
    cell.foodAddress = (FoodAddress *)self.foodAddressManager.foodAddressArray[indexPath.row];
    [cell.editButton addTarget:self action:@selector(cellEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == _selectedIndex) {
        cell.selectionImage.image = [UIImage imageNamed:@"selected"];
    } else {
        cell.selectionImage.image = [UIImage imageNamed:@"unselected"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    [tableView reloadData];
}

#pragma mark - private methods

#pragma mark - event response
- (void)cellEditButtonClicked:(id)sender {
    FoodShowAddressCell *cell = (FoodShowAddressCell *)[[(UIButton *)sender superview] superview];
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        FoodAddressEditViewController *vc = [[FoodAddressEditViewController alloc] init];
        vc.foodAddressToEdit = (FoodAddress *)self.foodAddressManager.foodAddressArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"没找到cell");
    }
}

- (IBAction)addAddressButtonClicked:(id)sender {
    FoodOrderAddAddressViewController *vc = [[FoodOrderAddAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getters and setters
- (FoodAddressManager *)foodAddressManager {
    if (!_foodAddressManager) {
        _foodAddressManager = [FoodAddressManager sharedInstance];
    }
    return _foodAddressManager;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.delegate) {
        if (self.delegate) {
            [self.delegate foodAddressSelectionViewController:self didSelectIndex:self.selectedIndex];
        }
    }
}

@end
