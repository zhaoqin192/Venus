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
#import "UIButton+Badge.h"
#import "FoodOrderViewSectionObject.h"
#import "FoodOrderViewBaseItem.h"
#import "FoodSubmitOrderViewController.h"
#import "AccountDao.h"
#import "DatabaseManager.h"
#import "NetworkFetcher+Food.h"
#import "MBProgressHUD.h"
#import "GMLoginViewController.h"
#import "PureLayout.h"
#import "FoodOrderViewSectionObject.h"
#import "FoodOrderViewBaseItem.h"
#import "FoodTrolleyTableViewCell.h"


@interface FoodDetailViewController ()<TouchLabelDelegate, UITableViewDelegate, UITableViewDataSource>{
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

@property (strong, nonatomic) UITableView *trolleyTableView;
@property (assign, nonatomic) NSInteger orderFoodKindCount;


@end

@implementation FoodDetailViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Group 11"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    //从分类中跳转，只有id参数，需要重新获取数据
    if (self.restaurantID) {
        @weakify(self)
        [NetworkFetcher foodFetcherRestaurantInfoWithID:self.restaurantID success:^(NSDictionary *response) {
            @strongify(self)
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                [Restaurant mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                                @"identifier": @"id",
                                @"pictureUrl": @"icon",
                                @"packFee": @"pack_fee",
                                @"costTime": @"cost_time",
                                @"describer": @"description",
                                @"basePrice": @"base_price"
                               };
                }];
                self.restaurant = [Restaurant mj_objectWithKeyValues:response[@"data"]];
                [self initViews];
                [self configureChildController];
                self.navigationItem.title = _restaurant.name;
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"请求错误";
                [hud hide:YES afterDelay:1.5f];
            }
        } failure:^(NSString *error) {
            @strongify(self)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络异常";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else {
        [self initViews];
        [self configureChildController];
        self.navigationItem.title = _restaurant.name;
    }
    
    
    
    [self.view addSubview:[self segementView]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    self.navigationController.navigationBar.translucent = YES;
    
//    UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"store"] style:UIBarButtonItemStyleDone target:self action:@selector(enterStore)];
//    UIBarButtonItem *groupBuyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groupBuy"] style:UIBarButtonItemStyleDone target:self action:@selector(enterGroupBuy)];
//    storeButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -40);
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:groupBuyButton, storeButton,nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.trolleyFoodArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodTrolleyTableViewCell *cell = [FoodTrolleyTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.trolleyFoodArray.count) {
        cell.food = (FoodOrderViewBaseItem *)self.trolleyFoodArray[indexPath.row];
        [cell.minusButton addTarget:self action:@selector(trolleyMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addButton addTarget:self action:@selector(trolleyAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *trollyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopingbag"]];
    trollyImage.frame = CGRectMake(10, 11, 19, 20);
    [view addSubview:trollyImage];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, 11, 42, 21)];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"购物车";
    label.textColor = GMBrownColor;
    
    UIButton *deleteTrolley = [[UIButton alloc] init];
    [deleteTrolley setImage:[UIImage imageNamed:@"dustbin"] forState:UIControlStateNormal];
    [view addSubview:deleteTrolley];
    [deleteTrolley addTarget:self action:@selector(deleteTrollyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [deleteTrolley autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    [deleteTrolley autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
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
}

- (void)deleteTrollyButtonClicked:(id)sender {
    for (FoodOrderViewBaseItem *baseItem in self.trolleyFoodArray) {
        baseItem.orderCount = 0;
    }
    [self.trolleyFoodArray removeAllObjects];
    [self.trolleyTableView reloadData];
    self.trollyButtonBadgeCount = 0;
    self.totalPrice = 0.0;
    [self.orderVC clearOrderFood];
    [[self.orderVC dataTableView] reloadData];
    self.trolleyTableView.hidden = YES;
    self.shadowView.hidden = YES;
}

- (IBAction)trollyButtonClicked:(id)sender {
    
    if (_trollyButtonBadgeCount == 0) {
        return;
    } else {
        if (!self.trolleyTableView.hidden) {
            self.trolleyTableView.hidden = YES;
            self.shadowView.hidden = YES;
        } else {
            // 设置tableview的frame
            self.orderFoodKindCount = 0;
            [self.trolleyFoodArray removeAllObjects];
            for (FoodOrderViewSectionObject *sectionObject in self.orderVC.sections) {
                for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
                    if (baseItem.orderCount > 0) {
                        self.orderFoodKindCount += 1;
                        [self.trolleyFoodArray addObject:baseItem];
                    }
                }
            }
            [self.trolleyTableView reloadData];
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = 32.0 + 40.0 * self.orderFoodKindCount + 20.0;
            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
            self.trolleyTableView.frame = CGRectMake(0, y, width, height);
            
            self.trolleyTableView.hidden = NO;
            self.shadowView.hidden = NO;
            [self.view insertSubview:self.segementView belowSubview:self.shadowView];
            [self.view insertSubview:self.trolleyTableView belowSubview:self.trollyButton];
            [self.view insertSubview:self.navigationController.navigationBar belowSubview:self.shadowView];
        }
    }
    
    
    
    
    
//    if (_trollyButtonBadgeCount != 0) {
//        // 背景变暗
//        if (self.shadowView.hidden == YES) {
//            self.shadowView.hidden = NO;
//            [self.view insertSubview:self.segementView belowSubview:self.shadowView];
//            [self.view insertSubview:self.navigationController.navigationBar belowSubview:self.shadowView];
//        } else {
//            self.shadowView.hidden = YES;
//        }
//        
//        // 弹出table view
//        if (_foodTrolleyTableViewController) {
//            [_foodTrolleyTableViewController.foodArray removeAllObjects];
//            for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
//                for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
//                    if (baseItem.orderCount > 0) {
//                        [_foodTrolleyTableViewController.foodArray addObject:baseItem];
//                    }
//                }
//            }
//            
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
//            CGFloat height = 32.0 + 40.0 * _foodTrolleyTableViewController.foodArray.count + 20.0;
//            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
//            _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
//            
//            [_foodTrolleyTableViewController.tableView reloadData];
//            if (!_foodTrolleyTableViewController.view.hidden) {
//                [_foodTrolleyTableViewController didMoveToParentViewController:self];
//                
//            } else {
//                [_foodTrolleyTableViewController willMoveToParentViewController:nil];
//                [_foodTrolleyTableViewController removeFromParentViewController];
//            }
//            _foodTrolleyTableViewController.view.hidden = !_foodTrolleyTableViewController.view.hidden;
//        } else {
//            _foodTrolleyTableViewController = [[FoodTrolleyTableViewController alloc] init];
//            [self addChildViewController:_foodTrolleyTableViewController];
//            [_foodTrolleyTableViewController didMoveToParentViewController:self];
//            
//            for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
//                for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
//                    if (baseItem.orderCount > 0) {
//                        [_foodTrolleyTableViewController.foodArray addObject:baseItem];
//                    }
//                }
//            }
//            
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
//            CGFloat height = 32.0 + 40.0 * _foodTrolleyTableViewController.foodArray.count + 25.0;
//            CGFloat y = [UIScreen mainScreen].bounds.size.height - height - 50.0;
//            _foodTrolleyTableViewController.view.frame = CGRectMake(0, y, width, height);
//            [self.view insertSubview:_foodTrolleyTableViewController.view belowSubview:self.trollyButton];
//        }
//    }
}

- (IBAction)shadowViewTouched:(id)sender {
    [self trollyButtonClicked:sender];
}

- (IBAction)confirmOrderButtonClicked:(id)sender {
    if (self.totalPrice == 0) {
        return;
    }
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    if ([accountDao isLogin]) {
        // 创建订单，传入下一个
        FoodSubmitOrderViewController *vc = [[FoodSubmitOrderViewController alloc] init];
        vc.restaurantName = _restaurant.name;
        vc.restaurantID = _restaurant.identifier;
        vc.bargainFee = 0.0;
        vc.costTime = [_restaurant.costTime integerValue];
        vc.shippingFee = [_restaurant.packFee floatValue];
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
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)trolleyMinusButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodTrolleyTableViewCell *cell = (FoodTrolleyTableViewCell *)[[button superview] superview];
    if (cell) {
        if  (cell.food.orderCount > 0) {
            cell.food.orderCount -= 1;
            cell.foodCount.text = [NSString stringWithFormat:@"%li",(long)([cell.foodCount.text integerValue] - 1)];
            CGFloat unitPrice = cell.food.unitPrice;
            CGFloat totalPrice = cell.food.orderCount * unitPrice;
            cell.foodTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
            
            self.totalPrice -= unitPrice;
            self.trollyButtonBadgeCount -= 1;
            [self.orderVC.dataTableView reloadData];
        }
        if (cell.food.orderCount == 0) {
            NSIndexPath *indexPath = [self.trolleyTableView indexPathForCell:cell];
            [self deleteCellAtIndexPath:indexPath];
        }
    }
}

- (void)trolleyAddButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodTrolleyTableViewCell *cell = (FoodTrolleyTableViewCell *)[[button superview] superview];
    if (cell) {
        if (cell.foodCount >= 0) {
            cell.minusButton.enabled = YES;
        }
        
        cell.food.orderCount += 1;
        cell.foodCount.text = [NSString stringWithFormat:@"%li",(long)([cell.foodCount.text integerValue] + 1)];
        CGFloat unitPrice = cell.food.unitPrice;
        CGFloat totalPrice = cell.food.orderCount * unitPrice;
        cell.foodTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
        
        self.totalPrice += unitPrice;
        self.trollyButtonBadgeCount += 1;
        [self.orderVC.dataTableView reloadData];
        
        
    }
}

#pragma mark - private methods

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.trolleyFoodArray removeObjectAtIndex:indexPath.row];
    if (self.trolleyFoodArray.count != 0) {
        [self.trolleyTableView reloadData];
        [self resizeTrolly];
    } else {
        self.trollyButtonBadgeCount = 0;
        self.totalPrice = 0.0;
        [[self.orderVC dataTableView] reloadData];
        [self deleteTrolly];
    }
}

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
    self.trolleyTableView.hidden = YES;
}

- (void)resizeTrolly {
    CGFloat y = self.trolleyTableView.frame.origin.y + 40.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.trolleyTableView.frame.size.height - 40.0;
    self.trolleyTableView.frame = CGRectMake(0, y, width, height);
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

- (UITableView *)trolleyTableView {
    if (!_trolleyTableView) {
        _trolleyTableView = [[UITableView alloc] init];
        [self.view addSubview:_trolleyTableView];
        _trolleyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trolleyTableView.scrollEnabled = NO;
        _trolleyTableView.delegate = self;
        _trolleyTableView.dataSource = self;
    }
    return _trolleyTableView;
}

- (FoodTrolleyTableViewController *)foodTrolleyTableViewController {
    if (!_foodTrolleyTableViewController) {
        _foodTrolleyTableViewController = [[FoodTrolleyTableViewController alloc] init];
        for (FoodOrderViewSectionObject *sectionObject in _orderVC.sections) {
            for (FoodOrderViewBaseItem *baseItem in sectionObject.items) {
                if (baseItem.orderCount > 0) {
                    [_foodTrolleyTableViewController.foodArray addObject:baseItem];
                }
            }
        }
    }
    return _foodTrolleyTableViewController;
}

- (NSMutableArray *)trolleyFoodArray {
    if (!_trolleyFoodArray) {
        _trolleyFoodArray = [[NSMutableArray alloc] init];
    }
    return _trolleyFoodArray;
}

@end
