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
//#import "NetworkFetcher+Food.h"
#import "UIButton+Badge.h"
#import "FoodOrderViewSectionObject.h"
#import "FoodOrderViewBaseItem.h"
#import "FoodSubmitOrderViewController.h"
#import "AccountDao.h"
//#import "FoodManager.h"
//#import "ResFoodClass.h"
//#import "ResFood.h"


@interface FoodDetailViewController ()<TouchLabelDelegate>{
    XFSegementView *_segementView;
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
@property (weak, nonatomic) IBOutlet UILabel *totalPriceText;

@property (strong, nonatomic) FoodCommitViewController *commitVC;

@property (strong, nonatomic) FoodTrolleyTableViewController *foodTrolleyTableViewController;
@property (assign, nonatomic) NSInteger currentVCIndex;

@end

@implementation FoodDetailViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self initViews];
    
    [self configureChildController];
    [self.view addSubview:[self segementView]];

    // 移动到commentController
//    [NetworkFetcher foodFetcherCommentListWithID:_restaurant.identifier level:@"0" success:^{
//        
//    } failure:^(NSString *error) {
//        
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.title = _restaurant.name;
    self.view.frame = CGRectMake(0, -66, kScreenWidth, kScreenHeight);
    
    UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"store"] style:UIBarButtonItemStyleDone target:self action:@selector(enterStore)];
    UIBarButtonItem *groupBuyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groupBuy"] style:UIBarButtonItemStyleDone target:self action:@selector(enterGroupBuy)];
    storeButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:groupBuyButton, storeButton,nil];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.rdv_tabBarController setTabBarHidden:NO];
}

#pragma mark - event response
- (void)enterStore {
    
}

- (void)enterGroupBuy {
    
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

- (IBAction)getBackToLastView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)trollyButtonClicked:(id)sender {
    if (_trollyButtonBadgeCount != 0) {
        // 背景变暗
        if (self.shadowView.hidden == YES) {
            self.shadowView.hidden = NO;
            [self.view insertSubview:self.segementView belowSubview:self.shadowView];
            [self.view insertSubview:self.navigationController.navigationBar belowSubview:self.shadowView];
        } else {
            self.shadowView.hidden = YES;
        }
        
        // 弹出table view
        if (_foodTrolleyTableViewController) {
            [_foodTrolleyTableViewController.foodArray removeAllObjects];
            for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
                for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
                    if (baseItem.orderCount > 0) {
                        [_foodTrolleyTableViewController.foodArray addObject:baseItem];
                    }
                }
            }
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = 32.0 + 40.0 * _foodTrolleyTableViewController.foodArray.count + 20.0;
            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
            _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
            
            [_foodTrolleyTableViewController.tableView reloadData];
            _foodTrolleyTableViewController.view.hidden = !_foodTrolleyTableViewController.view.hidden;
        } else {
            _foodTrolleyTableViewController = [[FoodTrolleyTableViewController alloc] init];
            [self addChildViewController:_foodTrolleyTableViewController];
            [_foodTrolleyTableViewController didMoveToParentViewController:self];
            
            for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
                for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
                    if (baseItem.orderCount > 0) {
                        [_foodTrolleyTableViewController.foodArray addObject:baseItem];
                    }
                }
            }
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = 32.0 + 40.0 * _foodTrolleyTableViewController.foodArray.count + 25.0;
            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
            _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
            [self.view insertSubview:_foodTrolleyTableViewController.view belowSubview:self.trollyButton];
        }
    }
}

- (IBAction)shadowViewTouched:(id)sender {
    [self trollyButtonClicked:sender];
}

- (IBAction)confirmOrderButtonClicked:(id)sender {
    if (self.totalPrice == 0) {
        return;
    }
    AccountDao *account = [[AccountDao alloc] init];
    if (account.isLogin) {
        // 创建订单，传入下一个
        FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
        vc.restaurantName = _restaurant.name;
        vc.restaurantID = _restaurant.identifier;
        vc.bargainFee = 10.0;
        vc.shippingFee = 20.0;
        for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
            for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
                if (baseItem.orderCount > 0) {
                    vc.totalPrice += baseItem.orderCount * baseItem.unitPrice;
                    [vc.foodArray addObject:baseItem];
                }
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 弹出登录界面
    }
}

#pragma mark - private methods

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initViews {
    self.salesText.text = [@"月销量 " stringByAppendingString:_restaurant.sales];
    self.noteText.text = [@"通知:" stringByAppendingString:_restaurant.describer];
    self.priceText.text = [NSString stringWithFormat:@"起送价￥%@ 配送费￥%@ 配送时间%@分钟", _restaurant.basePrice, _restaurant.packFee, _restaurant.costTime];
    [self.restaurantPic sd_setImageWithURL:[NSURL URLWithString:_restaurant.pictureUrl]];
    self.totalPrice = 0;
}

- (void)configureChildController {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.commitVC = [[FoodCommitViewController alloc] init];
    self.commitVC.restaurant = _restaurant;
    self.orderVC = [[FoodOrderViewController alloc] initWithRestaurantIdentifier:_restaurant.identifier];
    [self addChildViewController:self.orderVC];
    [self.orderVC didMoveToParentViewController:self];
    
    [self.orderVC.view setFrame:self.placeholderView.bounds];
    [self.placeholderView addSubview:self.orderVC.view];
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

#pragma mark - public methods
- (void)deleteTrolly {
    self.shadowView.hidden = YES;
    self.foodTrolleyTableViewController.view.hidden = YES;
}

- (void)resizeTrolly {
    CGFloat y = _foodTrolleyTableViewController.view.frame.origin.y + 40.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = _foodTrolleyTableViewController.view.frame.size.height - 40.0;
    _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
}

#pragma mark - getters and setters

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

- (XFSegementView *)segementView {
    if (_segementView) {
        return _segementView;
    } else {
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, 40)];
        _segementView.titleArray = @[@"点菜",@"评论"];
        _segementView.titleColor = [UIColor lightGrayColor];
        _segementView.haveRightLine = YES;
        _segementView.separateColor = [UIColor grayColor];
        [_segementView.scrollLine setBackgroundColor:GMBrownColor];
        _segementView.titleSelectedColor = GMBrownColor;
        _segementView.touchDelegate = self;
        [_segementView selectLabelWithIndex:0];
        _currentVCIndex = 0;
        return _segementView;
    }
}

- (void)setTotalPrice:(CGFloat)totalPrice {
    _totalPrice = totalPrice;
    NSString *price = [NSString stringWithFormat:@"共%.2f元",totalPrice];
    NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:price];
    [attributedPrice addAttribute:NSForegroundColorAttributeName value:GMBrownColor range:NSMakeRange(0, 1)];
    [attributedPrice addAttribute:NSForegroundColorAttributeName value:GMBrownColor range:NSMakeRange(price.length - 1, 1)];
    self.totalPriceText.attributedText = attributedPrice;
}

@end
