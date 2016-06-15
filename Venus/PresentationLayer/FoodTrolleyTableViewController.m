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

//- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.translucent = NO;
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.translucent = YES;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FoodTrolleyTableViewController"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FoodTrolleyTableViewController"];
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
    [_foodArray removeAllObjects];
    [self.tableView reloadData];
    __weak FoodDetailViewController *vc = (FoodDetailViewController *)self.parentViewController;
    if (vc) {
        vc.trollyButtonBadgeCount = 0;
        vc.totalPrice = 0.0;
        [[(FoodOrderViewController *)vc.orderVC dataTableView] reloadData];
        [vc deleteTrolly];
    }
}

- (void)cellAddButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    __weak FoodTrolleyTableViewCell *cell = (FoodTrolleyTableViewCell *)[[button superview] superview];
    if (cell) {
        cell.food.orderCount += 1;
        cell.foodCount.text = [NSString stringWithFormat:@"%li",(long)([cell.foodCount.text integerValue] + 1)];
        CGFloat unitPrice = cell.food.unitPrice;
        CGFloat totalPrice = cell.food.orderCount * unitPrice;
        cell.foodTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
        __weak FoodDetailViewController *vc = (FoodDetailViewController *)self.parentViewController;
        vc.totalPrice += unitPrice;
        vc.trollyButtonBadgeCount += 1;
        [vc.orderVC.dataTableView reloadData];
    }
}

- (void)cellMinusButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    __weak FoodTrolleyTableViewCell *cell = (FoodTrolleyTableViewCell *)[[button superview] superview];
    if (cell) {
        if  (cell.food.orderCount > 0) {
            cell.food.orderCount -= 1;
            cell.foodCount.text = [NSString stringWithFormat:@"%li",(long)([cell.foodCount.text integerValue] - 1)];
            CGFloat unitPrice = cell.food.unitPrice;
            CGFloat totalPrice = cell.food.orderCount * unitPrice;
            cell.foodTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
            
            __weak FoodDetailViewController *vc = (FoodDetailViewController *)self.parentViewController;
            vc.totalPrice -= unitPrice;
            vc.trollyButtonBadgeCount -= 1;
            [vc.orderVC.dataTableView reloadData];
        }
        if (cell.food.orderCount == 0) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self deleteCellAtIndexPath:indexPath];
        }
    }
    
}

#pragma mark - private methods

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.foodArray removeObjectAtIndex:indexPath.row];
    __weak FoodDetailViewController *vc = (FoodDetailViewController *)self.parentViewController;
    if (self.foodArray.count != 0) {
        [self.tableView reloadData];
        [vc resizeTrolly];
    } else {
        if (vc) {
            vc.trollyButtonBadgeCount = 0;
            vc.totalPrice = 0.0;
            [[(FoodOrderViewController *)vc.orderVC dataTableView] reloadData];
            [vc deleteTrolly];
        }
    }
}

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
