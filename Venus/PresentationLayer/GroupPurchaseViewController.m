//
//  GroupPurchaseViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GroupPurchaseViewController.h"
#import "XFSegementView.h"
#import "PackageViewController.h"
#import "MoneyCardViewController.h"

@interface GroupPurchaseViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}

@property (strong, nonatomic) PackageViewController *packageVC;
@property (strong, nonatomic) MoneyCardViewController *moneyVC;
@end

@implementation GroupPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureChildController];
    [self configureSegmentView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self touchLabelWithIndex:0];
}

- (void)configureChildController{
    self.packageVC = [[PackageViewController alloc] init];
    [self addChildViewController:self.packageVC];
    self.moneyVC = [[MoneyCardViewController alloc] init];
    [self addChildViewController:self.moneyVC];
}

- (void)configureSegmentView{
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    segementView.titleArray = @[@"套餐券",@"代金券"];
    segementView.titleColor = [UIColor lightGrayColor];
    segementView.haveRightLine = YES;
    segementView.separateColor = [UIColor grayColor];
    [segementView.scrollLine setBackgroundColor:GMBrownColor];
    segementView.titleSelectedColor = GMBrownColor;
    segementView.touchDelegate = self;
    [segementView selectLabelWithIndex:0];
    [self.view addSubview:segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    if (index == 0) {
        self.packageVC.view.frame = CGRectMake(0, 104, kScreenWidth, kScreenHeight - 104);
        [self.view addSubview:self.packageVC.view];
    }
    else{
        self.moneyVC.view.frame = CGRectMake(0, 104, kScreenWidth, kScreenHeight - 104);
        [self.view addSubview:self.moneyVC.view];
    }
}


@end