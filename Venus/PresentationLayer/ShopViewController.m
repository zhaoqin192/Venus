//
//  ShopViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopViewController.h"
#import "XFSegementView.h"
#import "ShopCommitViewController.h"
#import "ShopAllViewController.h"
@interface ShopViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}

@property (strong, nonatomic) ShopCommitViewController *commitVC;
@property (strong, nonatomic) ShopAllViewController *allVC;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GMBgColor;
    [self configureChildController];
    [self configureSegmentView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self touchLabelWithIndex:0];
}

- (void)configureChildController{
    self.commitVC = [[ShopCommitViewController alloc] init];
    [self addChildViewController:self.commitVC];
    self.allVC = [[ShopAllViewController alloc] init];
    [self addChildViewController:self.allVC];
}

- (void)configureSegmentView{
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, 40)];
    segementView.titleArray = @[@"店铺首页",@"全部宝贝",@"评价"];
    segementView.titleColor = [UIColor lightGrayColor];
    segementView.haveRightLine = YES;
    segementView.separateColor = [UIColor grayColor];
    [segementView.scrollLine setBackgroundColor:GMBrownColor];
    segementView.titleSelectedColor = GMBrownColor;
    segementView.touchDelegate = self;
    segementView.backgroundColor = [UIColor whiteColor];
    [segementView selectLabelWithIndex:0];
    [self.view addSubview:segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    if (index == 0) {
//        self.packageVC.view.frame = CGRectMake(0, 104, kScreenWidth, kScreenHeight - 104);
//        [self.view addSubview:self.packageVC.view];
    }
    else if(index == 1){
        self.allVC.view.frame = CGRectMake(0, 270, kScreenWidth, kScreenHeight - 270);
        [self.view addSubview:self.allVC.view];
    }
    else{
        self.commitVC.view.frame = CGRectMake(0, 270, kScreenWidth, kScreenHeight - 270);
        [self.view addSubview:self.commitVC.view];
    }
}

@end
