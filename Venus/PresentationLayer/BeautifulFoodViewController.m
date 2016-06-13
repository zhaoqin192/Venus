//
//  BeautifulFoodViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautifulFoodViewController.h"
#import "JSDropDownMenu.h"
#import "BeautifulFoodCell.h"
#import "BeautifulDetailViewController.h"
#import "BeautifulFood.h"
#import "BeautyCategory.h"

@interface BeautifulFoodViewController()
<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSArray *foodArray;
@property (nonatomic, copy) NSArray *categoryArray;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) JSDropDownMenu *menu;

@end

@implementation BeautifulFoodViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _categoryIndex = -1;
        _identify = 10000; //美食类别id
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCategory];
    self.view.backgroundColor = [UIColor redColor];
    [self configureTableView];
    self.navigationItem.title = self.myTitle;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStyleDone handler:^(id sender) {
//        NSLog(@"搜索");
//    }];
    self.order = @(0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)loadData {
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/shop/listShops"]];
    NSDictionary *parameters = @{@"id":@(self.identify),@"order":self.order};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [BeautyCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"identify": @"id"
                     };
        }];
        [BeautifulFood mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"activity":@"BeautyCategory"};
        }];
        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"desp": @"description",
                     @"identify":@"id"
                     };
        }];
        self.foodArray = [BeautifulFood mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCategory {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/shop/getSecondCat?"]];
    NSDictionary *parameters = @{@"id":@(self.identify)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"category %@",responseObject);
        [BeautyCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"identify": @"id"
                     };
        }];
        self.categoryArray = [BeautyCategory mj_objectArrayWithKeyValuesArray:responseObject[@"cat"]];
        _data1 = [NSMutableArray array];
        [_data1 removeAllObjects];
        [_data1 addObject:@"分类"];
        for (BeautyCategory *cate in self.categoryArray) {
            NSString *name = cate.name;
            [_data1 addObject:name];
        }
        [self configureMenu];
        if (self.categoryIndex == -1) {
            [self loadData];
        }
        else {
            BeautyCategory *category = self.categoryArray[self.categoryIndex];
            [self loadCategoryShop:category.identify];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"category %@",error);
    }];
}

- (void)loadCategoryShop:(NSInteger )identify {
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/shop/listShops"]];
    NSDictionary *parameters = @{@"id":@(identify),
                                 @"order":self.order};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [BeautyCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"identify": @"id"
                     };
        }];
        [BeautifulFood mj_setupObjectClassInArray:^NSDictionary *{
           return @{@"activity":@"BeautyCategory"};
        }];
        [BeautifulFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"identify":@"id"};
        }];
        self.foodArray = [BeautifulFood mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.myTableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)configureTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BeautifulFoodCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([BeautifulFoodCell class])];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)configureMenu{
    
//    _data1 = [NSMutableArray arrayWithObjects:@"分类", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"筛选", @"团购", @"外卖", @"活动", nil];
    
    _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    _menu.dataSource = self;
    _menu.delegate = self;
}

#pragma mark <TableDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foodArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeautifulFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BeautifulFoodCell class])];
    cell.model = self.foodArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BeautifulDetailViewController *vc = [[BeautifulDetailViewController alloc] init];
    BeautifulFood *model = self.foodArray[indexPath.row];
    vc.shopId = model.shopId;
    [self.navigationController pushViewController:vc animated:YES];
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

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        if (self.categoryIndex == -1) {
            return _currentData1Index;
        }
        else {
            return self.categoryIndex + 1;
        }
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _data1.count;
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:{
            if (self.categoryIndex == -1) {
                return _data1[0];
            }
            else {
                BeautyCategory *category = self.categoryArray[self.categoryIndex];
                NSLog(@"hahahahahhha  %@",category.name);
                return category.name;
            }
            break;
        }
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    } else  {
        return _data2[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 1) {
        _currentData2Index = indexPath.row;
        self.order = @(indexPath.row);
        if (self.categoryIndex == -1) {
            [self loadData];
            return;
        }
        BeautyCategory *category = self.categoryArray[self.categoryIndex];
        [self loadCategoryShop:category.identify];
    }
    else {
        _currentData1Index = indexPath.row;
        if (indexPath.row == 0) {
            self.categoryIndex = -1;
            [self loadData];
            return;
        }
        self.categoryIndex = indexPath.row - 1;
        BeautyCategory *category = self.categoryArray[self.categoryIndex];
        [self loadCategoryShop:category.identify];
        NSLog(@"%zd",indexPath.row);
    }
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

@end
