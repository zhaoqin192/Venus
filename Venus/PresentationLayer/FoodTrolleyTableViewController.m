//
//  FoodTrolleyTableViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodTrolleyTableViewController.h"

@interface FoodTrolleyTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FoodTrolleyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
