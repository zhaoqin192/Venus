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
#import "Commit.h"
#import "CouponModel.h"
#import "CouponViewController.h"
#import "BeautifulCommitView.h"

@interface BeautifulDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSString *currentSegmentName;
@property (nonatomic, copy) NSArray *allFoodArray;
@property (nonatomic, copy) NSArray *allActivityArray;
@property (nonatomic, strong) NSMutableArray *allCommitArray;
@property (nonatomic, copy) NSArray *allCouponsArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BeautifulCommitView *commitView;
@end

@implementation BeautifulDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentSegmentName = @"店铺首页";
    self.allCommitArray = [NSMutableArray array];
    [self configureTableView];
    [SVProgressHUD show];
    [self loadHomeData];
    [self configureNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)configureFootView {
    self.commitView.hidden = YES;
    self.webView.hidden = YES;
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
    else if ([self.currentSegmentName isEqualToString:@"评价"]) {
        self.commitView.hidden = NO;
    }
}

- (void)configureHeadView {
    UIView *headView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, kScreenWidth, 362);
        BeautyDetailHeaderView *headview = [BeautyDetailHeaderView headView];
        headview.frame = CGRectMake(0, 0, kScreenWidth, 362);
        headview.returnButtonClicked = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        headview.segmentButtonClicked = ^(NSInteger index) {
            if (index == 0) {
                self.currentSegmentName = @"店铺首页";
                [SVProgressHUD dismiss];
                [SVProgressHUD show];
                [self loadHomeData];
            }
            else if (index == 1) {
                self.currentSegmentName = @"全部宝贝";
                [SVProgressHUD dismiss];
                [SVProgressHUD show];
                [self loadFoodItem];
            }
            else {
                self.currentSegmentName = @"评价";
                [SVProgressHUD dismiss];
                [SVProgressHUD show];
                [self loadCommit];
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
    self.myTableView.backgroundColor = GMBgColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MoneyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MoneyCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopActivityCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodContentCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCommitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopCommitCell class])];
   // [self configureFootView];
    self.commitView = [BeautifulCommitView commitView];
    self.commitView.frame = CGRectMake(0, kScreenHeight-48, kScreenWidth, 48);
    __weak typeof(self)weakSelf = self;
    self.commitView.sendButtonTapped = ^(NSString *text){
        [SVProgressHUD show];
        [weakSelf sendCommit:text];
    };
    [self.view addSubview:self.commitView];
}

- (void)sendCommit:(NSString *)text {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/comment/insertComment"]];
   // NSLog(@"%@ %d",text,self.foodModel.shopId);
    NSDictionary *parameters = @{@"storeId":@(self.foodModel.shopId),
                                 @"ser_grade":@(5),
                                 @"des_grade":@(5),
                                 @"content":text,
                                 @"itemId":@(0)};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.commitView.textField.text = @"";
        [self.commitView.textField resignFirstResponder];
        [SVProgressHUD showWithStatus:@"评论成功！"];
        [self loadCommit];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
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
        [self loadCoupons];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCoupons {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/couponz/customer/storeAndCoupons"]];
    NSDictionary *parameters = @{@"storeWmId":@(self.foodModel.shopId)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        //            return @{
        //                     @"desp": @"description"
        //                     };
        //        }];
        [CouponModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"identifier": @"id",
                     @"pictureUrl": @"picUrl",
                     };
        }];
        self.allCouponsArray = [CouponModel mj_objectArrayWithKeyValuesArray:responseObject[@"coupons"]];
        [self configureFootView];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
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
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCommit {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/comment/getStoreComment"]];
    NSDictionary* parameters = @{
                                    @"storeId":@(self.foodModel.shopId),
                                    @"page":@"1",
                                    @"pageSize":@"20",
                                };
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        //            return @{
        //                     @"desp": @"description"
        //                     };
        //        }];
        self.allCommitArray = [Commit mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self configureFootView];
        self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
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
        else {
            return self.allCouponsArray.count;
        }
    }
    return self.allCommitArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        switch (indexPath.section) {
            case 0:{
                CouponViewController *vc = [[UIStoryboard storyboardWithName:@"group" bundle:nil] instantiateViewControllerWithIdentifier:@"CouponViewController"];
                vc.couponModel = self.allCouponsArray[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        switch (indexPath.section) {
            case 0:{
                MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoneyCell class])];
                cell.foodModel = self.allCouponsArray[indexPath.row];
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
        cell.isDisplay = YES;
        return cell;
    }
    else {
        ShopCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopCommitCell class])];
       // cell.contentView.backgroundColor = GMBgColor;
        cell.foodModel = self.allCommitArray[indexPath.row];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        return 10;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.currentSegmentName isEqualToString:@"店铺首页"]) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 9, kScreenWidth, 14)];
        label.font = [UIFont systemFontOfSize:14];
        [header addSubview:label];
        label.text = @"当前团购券";
        if (section == 1) {
            label.text = @"店铺活动";
        }
        return header;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - <Notification>

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.commitView.frame = CGRectMake(0, kScreenHeight-48-height, kScreenWidth, 48);
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.commitView.frame = CGRectMake(0, kScreenHeight-48, kScreenWidth, 48);
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
