//
//  MoneyCardViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MoneyCardViewController.h"
#import "MoneyCell.h"

@interface MoneyCardViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MoneyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MoneyCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([MoneyCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GMBgColor;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoneyCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
