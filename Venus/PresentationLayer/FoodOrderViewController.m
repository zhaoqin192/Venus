//
//  FoodOrderViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderViewController.h"
#import "FoodCategoryCell.h"

@interface FoodOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (copy, nonatomic) NSArray *categoryArray;
@end

@implementation FoodOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryArray = @[@"热门",@"特色菜",@"荤菜",@"素菜",@"主食",@"饮料"];
    [self configureTableView];
}

- (void)configureTableView{
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodCategoryCell class])];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.backgroundColor = GMBgColor;
}

#pragma mark <UITableView>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {
        return self.categoryArray.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        FoodCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCategoryCell class])];
        cell.content = self.categoryArray[indexPath.row];
        return cell;
    }
    else{
        return nil;
    }
}




@end
