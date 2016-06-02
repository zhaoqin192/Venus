//
//  HomeNewsViewController.m
//  Venus
//
//  Created by zhaoqin on 6/2/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "HomeNewsViewController.h"
#import "HomeNewsTableViewCell.h"
#import "HeadlineModel.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "WebViewController.h"

@interface HomeNewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"今日头条";
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)configureTableView {
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];

}

#pragma mark -UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headlineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeNewsTableViewCell className]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[HomeNewsTableViewCell className] configuration:^(HomeNewsTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = @"http://www.baidu.com";
    webVC.title = @"今日头条";
    [self.navigationController pushViewController:webVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configureCell:(HomeNewsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    HeadlineModel *model = [self.headlineArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    cell.abstractLabel.text = model.abstract;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
