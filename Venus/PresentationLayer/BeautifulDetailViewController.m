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
#import "ShopCommitCell.h"
#import "BeautifulFood.h"
#import "FoodDetail.h"
#import "Activity.h"

@interface BeautifulDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSString *currentSegmentName;
@property (nonatomic, copy) NSArray *allFoodArray;
@property (nonatomic, copy) NSArray *allActivityArray;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation BeautifulDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentSegmentName = @"店铺首页";
    [self configureTableView];
    [self loadHomeData];
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

- (void)configureFootView {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        self.myTableView.tableFooterView = self.webView;
        if (self.foodModel.description_url.length == 0) {
            self.webView.hidden = YES;
            return;
        }
        self.webView.hidden = NO;
        [self.webView loadHTMLString:self.foodModel.description_url baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
    }
}

- (void)configureHeadView {
    UIView *headView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, kScreenWidth, 346);
        BeautyDetailHeaderView *headview = [BeautyDetailHeaderView headView];
        headview.frame = CGRectMake(0, 0, kScreenWidth, 346);
        headview.returnButtonClicked = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        headview.segmentButtonClicked = ^(NSInteger index) {
            if (index == 0) {
                self.currentSegmentName = @"店铺首页";
                [self loadHomeData];
            }
            else if (index == 1) {
                self.currentSegmentName = @"全部宝贝";
                [self loadFoodItem];
            }
            else {
                self.currentSegmentName = @"评价";
                [self.myTableView reloadData];
            }
        };
        headview.foodModel = self.foodModel;
        [view addSubview:headview];
        view;
    });
    self.myTableView.tableHeaderView = headView;
}

- (void)configureTableView {
    [self configureHeadView];
    [self configureFootView];
    self.myTableView.backgroundColor = GMBgColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MoneyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MoneyCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopActivityCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodContentCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCommitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopCommitCell class])];
}

- (void)loadHomeData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/mallActivity/listActivityWithBrand"]];
    NSDictionary *parameters = @{@"brandId":@(self.foodModel.shopId)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        //            return @{
        //                     @"desp": @"description"
        //                     };
        //        }];
        self.allActivityArray = [Activity mj_objectArrayWithKeyValuesArray:responseObject[@"activity"]];
        [self configureFootView];
        [self.myTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadFoodItem {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/shop/getShopItem"]];
    NSDictionary *parameters = @{@"id":@(self.foodModel.shopId)};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
//        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{
//                     @"desp": @"description"
//                     };
//        }];
        self.allFoodArray = [FoodDetail mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
        self.myTableView.tableFooterView = [[UIView alloc] init];
        [self.myTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"全部宝贝"]) {
        return self.allFoodArray.count;
    }
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        if (section == 1) {
            return self.allActivityArray.count;
        }
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        switch (indexPath.section) {
            case 0:{
                MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoneyCell class])];
                return cell;
            }
                break;
            case 1:{
                ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopActivityCell class])];
                cell.activityModel = self.allActivityArray[indexPath.row];
                return cell;
            }
                break;
        }
        return nil;
    }
    else if ([self.currentSegmentName isEqualToString:@"全部宝贝"]) {
        FoodContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodContentCell class])];
        cell.contentView.backgroundColor = GMBgColor;
        cell.foodModel = self.allFoodArray[indexPath.row];
        return cell;
    }
    else {
        ShopCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopCommitCell class])];
        cell.contentView.backgroundColor = GMBgColor;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        switch (indexPath.section) {
            case 0:
                return 100;
                break;
            case 1:
                return 88;
                break;
        }
    }
    else if ([self.currentSegmentName isEqualToString:@"全部宝贝"]) {
        return 78;
    }
    else {
        return 90;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        return 32;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 9, kScreenWidth, 14)];
        label.font = [UIFont systemFontOfSize:14];
        [header addSubview:label];
        label.text = @"当前购物券";
        if (section == 1) {
            label.text = @"店铺活动";
        }
        return header;
    }
    return nil;
}

@end
