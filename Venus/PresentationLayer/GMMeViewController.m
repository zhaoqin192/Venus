//
//  GMMeViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeViewController.h"
#import "GMMeCell.h"
#import "GMMeOrderCell.h"

@interface GMMeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configureTableView {
    self.tableView.backgroundColor = GMBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GMMeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GMMeCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GMMeOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GMMeOrderCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"information"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"information"];
            }
            cell.textLabel.text = @"我的首页";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 1:{
            GMMeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeOrderCell class])];
            return cell;
            break;
        }
        case 2:{
            GMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的评价"];
                    cell.myLabel.text = @"我的评价";
                    return cell;
                    break;
                }
                case 1:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的收藏"];
                    cell.myLabel.text = @"我的收藏";
                    return cell;
                    break;
                }
                case 2:{
                    cell.myImageView.image = [UIImage imageNamed:@"客户服务"];
                    cell.myLabel.text = @"客户服务";
                    return cell;
                    break;
                }
                case 3:{
                    cell.myImageView.image = [UIImage imageNamed:@"账户中心"];
                    cell.myLabel.text = @"账户中心";
                    return cell;
                    break;
                }
                case 4:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的邀请"];
                    cell.myLabel.text = @"我的邀请";
                    return cell;
                    break;
                }
            }
        }
        case 3:{
            GMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.myImageView.image = [UIImage imageNamed:@"关于我们"];
            cell.myLabel.text = @"关于我们";
            return cell;
            break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 98;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}



@end