//
//  FoodViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodViewController.h"
#import "JSDropDownMenu.h"
#import "FoodCell.h"
#import "NetworkFetcher+Food.h"
#import "FoodManager.h"
#import "FoodClass.h"
#import "FoodDetailViewController.h"
#import "Restaurant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FoodDetailViewController.h"
#import "RDVTabBarController.h"


@interface FoodViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) FoodManager *foodManager;
@property (nonatomic, strong) JSDropDownMenu *menu;
@property (nonatomic, copy) NSMutableArray *data1;
@property (nonatomic, copy) NSMutableArray *data2;
@property (nonatomic, strong) FoodClass *foodClass;
@property (nonatomic, copy) NSMutableArray *restaurantArray;
@property (nonatomic, copy) NSString *sort;

@end

static const NSString *PICTUREURL = @"www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";


@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"外卖";
    [self configureMenu];
    [self configureTableView];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"外卖";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: GMBrownColor}];
    
    [self initObjects];
    [self networkRequest];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}


- (void)configureTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([FoodCell class])];
    //设置多余的seperator
    [self.myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.myTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}

- (void)initObjects {
    _foodManager = [FoodManager sharedInstance];
    _sort = @"0";
}

- (void)networkRequest {
    
    [NetworkFetcher foodFetcherClassWithSuccess:^{
        [_data1 removeAllObjects];
        for (FoodClass *foodClass in _foodManager.foodClassArray) {
            [_data1 addObject:foodClass.name];
        }
        _foodClass = _foodManager.foodClassArray[0];
        
        [self selectClassWithFoodClass:_foodClass sort:@"0" page:@"0"];
        
    } failure:^(NSString *error) {
        
    }];
    
    
}

- (void)selectClassWithFoodClass:(FoodClass *)foodClass sort:(NSString *)sort page:(NSString *)page {
    
    [NetworkFetcher foodFetcherRestaurantWithClass:foodClass sort:sort page:page success:^{
        
        _restaurantArray = foodClass.restaurantArray;
        [_myTableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
}

- (void)configureMenu{

    _data1 = [NSMutableArray arrayWithObjects:@"品牌商家", @"快餐类", @"小吃零食", @"甜品零食", @"果蔬生鲜", @"鲜花蛋糕", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"销量", @"评分", @"配送速度", @"起送价", @"默认", nil];
    
    _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    _menu.dataSource = self;
    _menu.delegate = self;
    
    [self.view addSubview:_menu];
}

#pragma mark <TableDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _restaurantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCell class])];

    Restaurant *restaurant = _foodClass.restaurantArray[indexPath.row];

    [cell.picture sd_setImageWithURL:[NSURL URLWithString:restaurant.pictureUrl]];
    cell.name.text = restaurant.name;
    cell.sales.text = restaurant.sales;
    cell.basePrice.text = [@"￥" stringByAppendingString:restaurant.basePrice];
    cell.packFee.text = [@"￥" stringByAppendingString:restaurant.packFee];
    cell.costTime.text = restaurant.costTime;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

// 分割线不靠左补全
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Restaurant *restaurant = _restaurantArray[indexPath.row];
    FoodDetailViewController *foodDetailVC = [[FoodDetailViewController alloc] init];
    foodDetailVC.restaurant = restaurant;
    [self.navigationController pushViewController:foodDetailVC animated:YES];
}


#pragma mark <MenuDelegate>

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column {
    
    return YES;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    
    if (column == 0) {
        
        return _currentData1Index;
        
    }
    if (column == 1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    
    if (column == 0) {
        return _data1.count;
    } else if (column == 1){
        
        return _data2.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
            return _data1[0];
            break;
        case 1:
            return _data2[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    } else {
        return _data2[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        _foodClass = _foodManager.foodClassArray[indexPath.row];
        _currentData1Index = indexPath.row;
        [self selectClassWithFoodClass:_foodClass sort:_sort page:@"0"];
    } else {
        _currentData2Index = indexPath.row;
        _sort = [NSString stringWithFormat:@"%ld", (long)_currentData2Index];
        [self selectClassWithFoodClass:_foodClass sort:_sort page:@"0"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
