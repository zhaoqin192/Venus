//
//  FoodDetialViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodDetialViewController.h"
#import "XFSegementView.h"

@interface FoodDetialViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;

}
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation FoodDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self configureSegmentView];
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
    NSLog(@"我是第%ld个label",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
