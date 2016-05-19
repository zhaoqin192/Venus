//
//  FoodTrolleyTableViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodTrolleyTableViewController.h"
#import "FoodTrolleyTableViewCell.h"
#import "FoodForOrdering.h"

@interface FoodTrolleyTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FoodTrolleyTableViewController

- (instancetype)initWithFoodArray:(NSMutableArray *)foodArray {
    if (self = [super init]) {
        if (foodArray) {
            _foodArray = [NSMutableArray arrayWithArray:foodArray];
        } else {
            _foodArray = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_foodArray.count != 0) {
        return _foodArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTrolleyTableViewCell *cell = [FoodTrolleyTableViewCell cellWithTableView:tableView];
    if (_foodArray) {
        cell.food = (FoodForOrdering *)_foodArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22.0;
}

@end
