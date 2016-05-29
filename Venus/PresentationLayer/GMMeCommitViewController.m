//
//  GMMeCommitViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/27.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeCommitViewController.h"
#import "XFSegementView.h"
#import "MeShopCommit.h"
#import "MeCommitCell.h"
#import "MeCouponCommit.h"

@interface GMMeCommitViewController ()<TouchLabelDelegate>{
    XFSegementView *_segementView;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSString *currentTitle;
@property (nonatomic, copy) NSArray *shopCommitArray;
@property (nonatomic, copy) NSArray *couponCommitArray;
@property (nonatomic, copy) NSArray *takeCommitArray;
@end

@implementation GMMeCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的评价";
    [self configureSegmentView];
    self.currentTitle = @"团购券";
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeCommitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MeCommitCell class])];
    [self loadCouponCommit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)configureSegmentView {
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    _segementView.titleArray = @[@"团购券",@"外卖",@"商城"];
    _segementView.titleColor = [UIColor lightGrayColor];
    _segementView.haveRightLine = YES;
    _segementView.separateColor = [UIColor grayColor];
    [_segementView.scrollLine setBackgroundColor:GMBrownColor];
    _segementView.titleSelectedColor = GMBrownColor;
    _segementView.touchDelegate = self;
    [_segementView selectLabelWithIndex:0];
    [self.view addSubview:_segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index {
    if (index == 0) {
        self.currentTitle = @"团购券";
        [self loadCouponCommit];
    }
    else if(index == 2) {
        self.currentTitle = @"商城";
        [self loadShopCommit];
    }
    else {
        self.currentTitle = @"外卖";
        [self loadMiamiCommit];
    }
}

- (void)loadCouponCommit {
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/couponz/customer/userComment"]];
    NSDictionary *parameters = nil;
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"coupon %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        NSDictionary *dic = responseObject[@"result"];
        NSMutableArray *array = [NSMutableArray array];
        for (id value in dic) {
            MeCouponCommit *commit = [[MeCouponCommit alloc] init];
            commit.time = [value[@"comment"][@"time"] integerValue];
            commit.score = [value[@"comment"][@"score"] integerValue];
            commit.content = value[@"comment"][@"content"];
            commit.picUrl = value[@"coupon"][@"picUrl"];
            commit.des = value[@"coupon"][@"dsc"];
            commit.abstract = value[@"coupon"][@"abstract"];
            [array addObject:commit];
        }
        self.couponCommitArray = [array copy];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"coupon %@", error);
    }];
}

- (void)loadShopCommit {
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/comment/getUserComment"]];
    NSDictionary *parameters = @{@"page":@(1),
                                 @"pageSize":@(100)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"shop %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        self.shopCommitArray = [MeShopCommit mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shop %@", error);
    }];
}

- (void)loadMiamiCommit {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/miami/customer/comment/getMyComments"]];
    NSDictionary *parameters = nil;
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"miami %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"miami %@", error);
    }];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.currentTitle isEqualToString:@"商城"]) {
        return self.shopCommitArray.count;
    }
    else if ([self.currentTitle isEqualToString:@"团购券"]) {
        return self.couponCommitArray.count;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeCommitCell class])];
    if ([self.currentTitle isEqualToString:@"商城"]) {
        cell.shopModel = self.shopCommitArray[indexPath.row];
    }
    else if ([self.currentTitle isEqualToString:@"团购券"]) {
        cell.couponModel = self.couponCommitArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
