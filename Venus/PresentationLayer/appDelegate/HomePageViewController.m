//
//  HomePageViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "HomePageViewController.h"
#import "SDCycleScrollView.h"
#import "HomeMenuCell.h"
#import "HomeNewsCell.h"
#import "HomeIntroduceCell.h"
#import "HomeCategoryCell.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "GMLoginViewController.h"

@interface HomePageViewController ()
<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SDCycleScrollView *scrollAdView;
@property (strong, nonatomic) NSMutableArray *menuArray;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if(account.token == nil){
        self.view.hidden = YES;
    }
    
    self.titleView.backgroundColor = GMRedColor;
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.view.isHidden) {
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [self presentViewController:vc animated:NO completion:^{
            weakSelf.view.hidden = NO;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (NSMutableArray *)menuArray{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNewsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeNewsCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeIntroduceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeIntroduceCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeCategoryCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = ({
        self.scrollAdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 220) delegate:self placeholderImage:[UIImage imageNamed:@"1"]];
        self.scrollAdView.localizationImageNamesGroup = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]];
        self.scrollAdView;
    });
}

- (void)configureScrollView{
//    [NetworkRequest requestSalesType:@(0) success:^{
//        self.salesArray = [SalesManager sharedManager].roundArray;
//        self.imageUrlArray = [[NSMutableArray alloc] init];
//        for (Sales *sale in self.salesArray) {
//            [self.imageUrlArray addObject:sale.imageURL];
//        }
//        self.scrollAdView.imageURLStringsGroup = self.imageUrlArray;
//    } failure:^{
//        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
//        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
//    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

#pragma mark <TableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3 + 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            static NSString *cellIndentifier = @"menucell";
            HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:self.menuArray];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeNewsCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.list = [@[@"1",@"2",@"3",@"4"] mutableCopy];
            cell.buttonClicked = ^(UIButton *button){
                NSLog(@"%ld",(long)button.tag);
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:{
            HomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCategoryCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 200;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 150;
            break;
        default:
            return 450;
            break;
    }
    return 0;
}

@end
