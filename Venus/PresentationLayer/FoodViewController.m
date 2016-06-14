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
#import "NewFoodDetailViewController.h"


@interface FoodViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger _currentcategoryDataIndex;
    NSInteger _currentsortDataIndex;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) JSDropDownMenu *menu;

//管理类，后面优化要用MVVM替换掉
@property (nonatomic, strong) FoodManager *foodManager;
//餐厅分类
@property (nonatomic, copy) NSMutableArray *categoryData;
//排序分类
@property (nonatomic, copy) NSMutableArray *sortData;
@property (nonatomic, strong) FoodClass *foodClass;
@property (nonatomic, copy) NSMutableArray *restaurantArray;
@property (nonatomic, copy) NSString *sort;
//当前页码
@property (nonatomic, assign) NSInteger currentPage;
//页码总数
@property (nonatomic, assign) NSInteger totalPage;


@end

static const NSString *PICTUREURL = @"www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";


@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = @"外卖";
    [self configureMenu];
    [self configureTableView];
    [self initObjects];
    [self networkRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];

}


- (void)configureTableView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = CGRectMake(0, 0, width, height);
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([FoodCell class])];
    //设置多余的seperator
    [self.myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.myTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}

- (void)initObjects {
    _foodManager = [FoodManager sharedInstance];
    _sort = @"0";
    self.currentPage = 1;
    self.totalPage = 1;
}

- (void)networkRequest {
    [NetworkFetcher foodFetcherClassWithSuccess:^{
        [self.categoryData removeAllObjects];
        for (FoodClass *foodClass in self.foodManager.foodClassArray) {
            [self.categoryData addObject:foodClass.name];
        }
        self.foodClass = self.foodManager.foodClassArray[0];
        [self selectClassWithFoodClass:self.foodClass sort:@"0" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
    } failure:^(NSString *error) {
        
    }];
}

- (void)selectClassWithFoodClass:(FoodClass *)foodClass sort:(NSString *)sort page:(NSString *)page {
    @weakify(self)
    [NetworkFetcher foodFetcherRestaurantWithClass:foodClass sort:sort page:page success:^(NSDictionary *response){
        @strongify(self)
        self.currentPage = [(NSNumber *)response[@"curPage"] integerValue];
        self.totalPage = [(NSNumber *)response[@"pageCount"] integerValue];
        _restaurantArray = foodClass.restaurantArray;
        [_myTableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
}

- (void)configureMenu{
    _categoryData = [NSMutableArray arrayWithObjects:@"全部", nil];
    _sortData = [NSMutableArray arrayWithObjects:@"默认", @"销量", @"评分", @"配送速度", @"起送价钱", nil];
    _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    _menu.dataSource = self;
    _menu.delegate = self;
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //加载更多数据
    if (self.currentPage != self.totalPage && indexPath.row == self.restaurantArray.count - 1) {
        [self selectClassWithFoodClass:_foodClass sort:_sort page:[NSString stringWithFormat:@"%ld", (long)++self.currentPage]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Restaurant *restaurant = _restaurantArray[indexPath.row];
    FoodDetailViewController *foodDetailVC = [[FoodDetailViewController alloc] init];
    foodDetailVC.restaurant = restaurant;
    foodDetailVC.restaurantID = [restaurant.identifier integerValue];
    [self.navigationController pushViewController:foodDetailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menu;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
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
        return _currentcategoryDataIndex;
    }
    if (column == 1) {
        return _currentsortDataIndex;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    if (column == 0) {
        return _categoryData.count;
    } else if (column == 1){
        return _sortData.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
            return _categoryData[0];
            break;
        case 1:
            return _sortData[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _categoryData[indexPath.row];
    } else {
        return _sortData[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        _foodClass = _foodManager.foodClassArray[indexPath.row];
        [self selectClassWithFoodClass:_foodClass sort:_sort page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
    } else {
        _sort = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [self selectClassWithFoodClass:_foodClass sort:_sort page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setters

- (FoodManager *)foodManager {
    if (!_foodManager) {
        _foodManager  = [FoodManager sharedInstance];
    }
    return _foodManager;
}

- (NSMutableArray *)categoryData {
    if (!_categoryData) {
        _categoryData = [[NSMutableArray alloc] init];
    }
    return _categoryData;
}

- (NSMutableArray *)sortData {
    if (!_sortData) {
        _sortData = [[NSMutableArray alloc] init];
    }
    return _sortData;
}

- (FoodClass *)foodClass {
    if (!_foodClass) {
        _foodClass = [[FoodClass alloc] init];
    }
    return _foodClass;
}

- (NSMutableArray *)restaurantArray {
    if (!_restaurantArray) {
        _restaurantArray = [[NSMutableArray alloc] init];
    }
    return _restaurantArray;
}

- (NSString *)sort {
    if (!_sort) {
        _sort = @"";
    }
    return _sort;
}

@end
