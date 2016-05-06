//
//  PackageViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "PackageViewController.h"
#import "PackageCell.h"
#import "TicketDetailViewController.h"

@interface PackageViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PackageCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([PackageCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GMBgColor;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PackageCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketDetailViewController *vc = [[TicketDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
