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
#import "Restaurant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NetworkFetcher+Food.h"



@interface FoodDetialViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPic;
@property (weak, nonatomic) IBOutlet UILabel *salesText;
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;



@property (strong, nonatomic) FoodCommitViewController *commitVC;
@property (strong, nonatomic) FoodOrderViewController *orderVC;
@end

@implementation FoodDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self configureChildController];
    [self configureSegmentView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self initViews];
    
    [NetworkFetcher foodFetcherRestaurantListWithID:_restaurant.identifier sort:@"2" success:^{
        [_orderVC updateOrder];
    } failure:^(NSString *error) {
        
    }];
    
    [NetworkFetcher foodFetcherCommentListWithID:_restaurant.identifier level:@"0" success:^{
        
    } failure:^(NSString *error) {
        
    }];
    
}

- (void)initViews {
    self.salesText.text = [@"月销量 " stringByAppendingString:_restaurant.sales];
    self.noteText.text = [@"通知:" stringByAppendingString:_restaurant.describer];
    self.priceText.text = [NSString stringWithFormat:@"起送价￥%@ 配送费￥%@ 配送时间%@分钟", _restaurant.basePrice, _restaurant.packFee, _restaurant.costTime];
    [self.restaurantPic sd_setImageWithURL:[NSURL URLWithString:_restaurant.pictureUrl]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = _restaurant.name;
    
    UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"store"] style:UIBarButtonItemStyleDone target:self action:@selector(enterStore)];
    UIBarButtonItem *groupBuyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groupBuy"] style:UIBarButtonItemStyleDone target:self action:@selector(enterGroupBuy)];
    storeButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:groupBuyButton, storeButton,nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = GMRedColor;
}

- (void)viewDidDisappear:(BOOL)animated {

}

- (void)enterStore {
    
}

- (void)enterGroupBuy {
    
}

- (void)configureChildController{
    self.commitVC = [[FoodCommitViewController alloc] init];
    self.commitVC.restaurant = _restaurant;
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
        self.commitVC.view.frame = CGRectMake(0, 180, kScreenWidth, kScreenHeight - 180 - 49);
        [self.view addSubview:self.commitVC.view];
    }
    else{
        self.orderVC.view.frame = CGRectMake(0, 180, kScreenWidth, kScreenHeight - 180 - 49);
        [self.view addSubview:self.orderVC.view];
    }
}

- (IBAction)getBackToLastView:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
