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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    [super viewWillAppear:animated];
    self.navigationItem.title = @"选择地址";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.foodAddressManager.foodAddressArray.count == 0) {
        return 1;
    } else {
        return self.foodAddressManager.foodAddressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodShowAddressCell *cell = [FoodShowAddressCell cellForTableView:tableView];
    cell.foodAddress = (FoodAddress *)self.foodAddressManager.foodAddressArray[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

#pragma mark - private methods

#pragma mark - event response

#pragma mark - getters and setters
- (FoodAddressManager *)foodAddressManager {
    if (!_foodAddressManager) {
        _foodAddressManager = [FoodAddressManager sharedInstance];
    }
    return _foodAddressManager;
}

@end
