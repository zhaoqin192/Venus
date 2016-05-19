//
//  FoodSubmitOrderViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodSubmitOrderViewController.h"
#import "FoodAddAddressCell.h"

@interface FoodSubmitOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FoodSubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 4:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
//            if (存在默认地址) {
//                显示地址cell
//            } else {
//                显示新增地址cell
//            }
            cell = [FoodAddAddressCell cellForTableView:tableView];
            break;
//        case 1:
//            cell =
            
        default:
            cell = [[UITableViewCell alloc] init];
            break;
    }
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

#pragma mark -- UITableViewDelegate


@end
