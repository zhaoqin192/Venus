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
#import "FoodTrolleyTableViewController.h"
#import "Restaurant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NetworkFetcher+Food.h"
#import "UIButton+Badge.h"
#import "FoodManager.h"
#import "ResFoodClass.h"
#import "ResFood.h"


@interface FoodDetailViewController ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPic;
@property (weak, nonatomic) IBOutlet UILabel *salesText;
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *priceText;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *trollyButton;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) FoodCommitViewController *commitVC;
@property (strong, nonatomic) FoodOrderViewController *orderVC;
@property (strong, nonatomic) FoodTrolleyTableViewController *foodTrolleyTableViewController;
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
        [self configureFoodArray];
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

- (void)configureFoodArray {
//    _foodArray = [[NSMutableArray alloc] init];
//    
//    FoodManager *foodManager = [FoodManager sharedInstance];
//    for (ResFoodClass *resFoodClass in foodManager.resFoodClassArray) {
//        NSMutableArray *foodArray = [[NSMutableArray alloc] init];
//        for (ResFood *resFood in resFoodClass.foodArray) {
//            resFood.count
//            [foodArray addObject:food];
//        }
//        [self.foodGroupArray addObject:foodArray];
//    }
//    NSLog(@"食物数组现在是：%@",self.foodGroupArray);
}

- (void)touchLabelWithIndex:(NSInteger)index {
    if (index == _currentVCIndex) {
        return;
    } else {
        switch (index) {
            case 0:
                [self cycleFromViewController:_commitVC toViewController:_orderVC];
                _currentVCIndex = 0;
                if (self.priceView.hidden == YES) {
                    self.priceView.hidden = NO;
                    self.trollyButton.hidden = NO;
                }
                break;
            case 1:
                [self cycleFromViewController:_orderVC toViewController:_commitVC];
                _currentVCIndex = 1;
                if (self.priceView.hidden == NO) {
                    self.priceView.hidden = YES;
                    self.trollyButton.hidden = YES;
                }
            default:
                break;
        }
    }
}

- (void)cycleFromViewController: (UIViewController*) oldVC
                toViewController: (UIViewController*) newVC {
    [self addChildViewController:newVC];
    [oldVC willMoveToParentViewController:nil];

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
    if (_trollyButtonBadgeCount != 0) {
        // 背景变暗
        if (self.shadowView.hidden == YES) {
            self.shadowView.hidden = NO;
            [self.view insertSubview:segementView belowSubview:_shadowView];
            [self.view insertSubview:self.navigationController.navigationBar belowSubview:_shadowView];
        } else {
            self.shadowView.hidden = YES;
        }
        
//        // 弹出table view
//        if (_foodTrolleyTableViewController) {
//            _foodTrolleyTableViewController.view.hidden = !_foodTrolleyTableViewController.view.hidden;
//        } else {
//            _foodForTrolleyArray = [[NSMutableArray alloc] init];
//            for (NSMutableArray *foodArray in _foodGroupArray) {
//                for (FoodForOrdering *food in foodArray) {
//                    if (food.foodCount > 0) {
//                        [_foodForTrolleyArray addObject:food];
//                    }
//                }
//            }
//            _foodTrolleyTableViewController = [[FoodTrolleyTableViewController alloc] initWithFoodArray:_foodForTrolleyArray];
//            [self addChildViewController:_foodTrolleyTableViewController];
//            [_foodTrolleyTableViewController didMoveToParentViewController:self];
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
//            CGFloat height = 32.0 + 22.0 * _foodForTrolleyArray.count;
//            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
//            _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
//            [self.view addSubview:_foodTrolleyTableViewController.view];
//        }
    }
}

- (IBAction)shadowViewTouched:(id)sender {
    self.shadowView.hidden = YES;
}

@end
