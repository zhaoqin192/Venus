//
//  FoodDetailViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "XFSegementView.h"
#import "FoodCommitViewController.h"
#import "FoodOrderViewController.h"
#import "Restaurant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NetworkFetcher+Food.h"
#import "UIButton+Badge.h"



@interface FoodDetailViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPic;
@property (weak, nonatomic) IBOutlet UILabel *salesText;
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (weak, nonatomic) IBOutlet UIButton *trollyButton;

@property (strong, nonatomic) FoodCommitViewController *commitVC;
@property (strong, nonatomic) FoodOrderViewController *orderVC;
@property (assign, nonatomic) NSInteger currentVCIndex;

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self configureChildController];
    [self configureSegmentView];
    _trollyButtonBadgeCount = 0;
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.title = _restaurant.name;
    
    UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"store"] style:UIBarButtonItemStyleDone target:self action:@selector(enterStore)];
    UIBarButtonItem *groupBuyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groupBuy"] style:UIBarButtonItemStyleDone target:self action:@selector(enterGroupBuy)];
    storeButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:groupBuyButton, storeButton,nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
}

- (void)enterStore {
    
}

- (void)enterGroupBuy {
    
}

- (void)setTrollyButtonBadgeCount: (NSInteger)trollyButtonBadgeCount {
    _trollyButtonBadgeCount = trollyButtonBadgeCount;
    if (trollyButtonBadgeCount != 0) {
        _trollyButton.badgeValue = [NSString stringWithFormat:@"%ld",(long)trollyButtonBadgeCount];
        _trollyButton.badgeBGColor = GMBrownColor;
        _trollyButton.badgeOriginX = _trollyButton.frame.size.width * 0.5;
        _trollyButton.badgeOriginY = _trollyButton.frame.size.height * 0.2;
    } else {
        _trollyButton.badgeValue = nil;
    }
}

- (void)configureChildController {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.commitVC = [[FoodCommitViewController alloc] init];
    self.commitVC.restaurant = _restaurant;
    self.orderVC = [[FoodOrderViewController alloc] init];
    [self addChildViewController:self.orderVC];
    [self.orderVC didMoveToParentViewController:self];
    
    [self.orderVC.view setFrame:self.placeholderView.bounds];
    [self.placeholderView addSubview:self.orderVC.view];
}

- (void)configureSegmentView {
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, 40)];
    segementView.titleArray = @[@"点菜",@"评论"];
    segementView.titleColor = [UIColor lightGrayColor];
    segementView.haveRightLine = YES;
    segementView.separateColor = [UIColor grayColor];
    [segementView.scrollLine setBackgroundColor:GMBrownColor];
    segementView.titleSelectedColor = GMBrownColor;
    segementView.touchDelegate = self;
    [segementView selectLabelWithIndex:0];
    _currentVCIndex = 0;
    [self.view addSubview:segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    if (index == _currentVCIndex) {
        return;
    } else {
        switch (index) {
            case 0:
                [self cycleFromViewController:_commitVC toViewController:_orderVC];
                _currentVCIndex = 0;
                break;
            case 1:
                [self cycleFromViewController:_orderVC toViewController:_commitVC];
                _currentVCIndex = 1;
            default:
                break;
        }
    }
}

- (void)cycleFromViewController: (UIViewController*) oldVC
               toViewController: (UIViewController*) newVC {
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    
    [self transitionFromViewController: oldVC toViewController: newVC
                              duration: 0.25 options:UIViewAnimationOptionTransitionNone
                            animations:nil
                            completion:^(BOOL finished) {
                                if (finished) {
                                    [newVC didMoveToParentViewController:self];
                                    [oldVC willMoveToParentViewController:nil];
                                    [oldVC removeFromParentViewController];
                                }
                            }];
}

- (IBAction)getBackToLastView:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    
}

- (IBAction)trollyButtonClicked:(id)sender {
    
}

@end
