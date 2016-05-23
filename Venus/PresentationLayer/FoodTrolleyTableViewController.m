//
//  FoodTrolleyTableViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodTrolleyTableViewController.h"
#import "FoodTrolleyTableViewCell.h"
#import "FoodOrderViewBaseItem.h"
#import "FoodDetailViewController.h"
#import "FoodOrderViewController.h"
#import "FoodTrolleyTableViewCell.h"

@interface FoodTrolleyTableViewController () <UITableViewDelegate, UITableViewDataSource>



@end

@implementation FoodTrolleyTableViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_foodArray.count > 0) {
        return _foodArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTrolleyTableViewCell *cell = [FoodTrolleyTableViewCell cellWithTableView:tableView];
    if (self.foodArray.count > indexPath.row) {
        cell.food = (FoodOrderViewBaseItem *)_foodArray[indexPath.row];
        [cell.addButton addTarget:self action:@selector(cellAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.minusButton addTarget:self action:@selector(cellMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

#pragma mark - event response
- (IBAction)deleteButtonClicked:(id)sender {
    for (FoodOrderViewBaseItem *baseItem in _foodArray) {
        baseItem.orderCount = 0;
    }
    [self.tableView reloadData];
    FoodDetailViewController *vc = (FoodDetailViewController *)self.parentViewController;
    if (vc) {
        vc.trollyButtonBadgeCount = 0;
        [[(FoodOrderViewController *)vc.orderVC dataTableView] reloadData];
        [vc deleteTrolly];
    }
}

- (void)cellAddButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodTrolleyTableViewCell *cell = (FoodTrolleyTableViewCell *)[[button superview] superview];
    if (cell) {
        
    }
}

- (void)cellMinusButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
}

#pragma mark - private methods

#pragma mark - getters and setters

- (NSMutableArray *)foodArray {
    if (_foodArray) {
        return _foodArray;
    } else {
        _foodArray = [[NSMutableArray alloc] init];
        return _foodArray;
    }
}


@end
