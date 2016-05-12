//
//  BeautifulDetailViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautifulDetailViewController.h"
#import "BeautyDetailHeaderView.h"
#import "MoneyCell.h"
#import "ShopActivityCell.h"
#import "FoodContentCell.h"

@interface BeautifulDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation BeautifulDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configureTableView {
    UIView *headView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, kScreenWidth, 296);
        BeautyDetailHeaderView *headview = [BeautyDetailHeaderView headView];
        headview.frame = CGRectMake(0, 0, kScreenWidth, 296);
        headview.returnButtonClicked = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [view addSubview:headview];
        view;
    });
    self.myTableView.tableHeaderView = headView;
    self.myTableView.backgroundColor = GMBgColor;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MoneyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MoneyCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopActivityCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodContentCell class])];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoneyCell class])];
            return cell;
        }
            break;
        case 1:{
            ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopActivityCell class])];
            return cell;
        }
            break;
        case 2:{
            FoodContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodContentCell class])];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return 88;
            break;
        case 2:
            return 78;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 9, kScreenWidth, 14)];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    label.text = @"当前购物券";
    if (section == 1) {
        label.text = @"店铺活动";
    }
    if (section == 2) {
        label.text = @"商品列表";
    }
    return header;
}

@end
