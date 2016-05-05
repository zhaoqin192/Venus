//
//  FoodDetialViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodDetialViewController.h"
#import "XFSegementView.h"
#import "FoodCommitViewController.h"
#import "FoodOrderViewController.h"

@interface FoodDetialViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) FoodCommitViewController *commitVC;
@property (strong, nonatomic) FoodOrderViewController *orderVC;
@end

@implementation FoodDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self configureChildController];
    [self configureSegmentView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configureChildController{
    self.commitVC = [[FoodCommitViewController alloc] init];
    [self addChildViewController:self.commitVC];
    self.orderVC = [[FoodOrderViewController alloc] init];
    [self addChildViewController:self.orderVC];
}

- (void)configureSegmentView{
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, 40)];
    segementView.titleArray = @[@"点菜",@"评论"];
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
    if (index == 1) {
        self.commitVC.view.frame = CGRectMake(0, 180, kScreenWidth, kScreenHeight - 180);
        [self.view addSubview:self.commitVC.view];
    }
    else{
        self.orderVC.view.frame = CGRectMake(0, 180, kScreenWidth, kScreenHeight - 180);
        [self.view addSubview:self.orderVC.view];
    }
}
- (IBAction)returnButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
