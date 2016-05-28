//
//  GMMeCommitViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/27.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeCommitViewController.h"
#import "XFSegementView.h"

@interface GMMeCommitViewController ()<TouchLabelDelegate>{
    XFSegementView *_segementView;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation GMMeCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的评价";
    [self configureSegmentView];
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
        [self loadCouponCommit];
    }
    else if(index == 2) {
        [self loadShopCommit];
    }
    else {
        [self loadMiamiCommit];
    }
}

- (void)loadCouponCommit {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"coupon %@", error);
    }];
}

- (void)loadShopCommit {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/comment/getUserComment"]];
    NSDictionary *parameters = @{@"page":@(0),
                                 @"pageSize":@(10)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"shop %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 0;
//}

@end
