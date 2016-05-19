//
//  FoodOrderViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderViewController.h"
#import "FoodCategoryCell.h"
#import "FoodContentCell.h"
#import "FoodDetailViewController.h"
#import "FoodManager.h"
#import "ResFoodClass.h"
#import "ResFood.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FoodOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (copy, nonatomic) NSMutableArray *categoryArray;
@property (nonatomic, copy) NSMutableArray *foodClassArray;
@property (nonatomic, copy) NSMutableArray *foodArray;
@property (nonatomic, strong) ResFoodClass *resFoodClass;
@property (nonatomic, strong) ResFood *resFood;
@property (nonatomic, strong) FoodManager *foodManager;
@property (nonatomic, strong) NSMutableArray *foodCountArray;
@property (assign, nonatomic) NSInteger currentFoodClassIndex;

@end

@implementation FoodOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _categoryArray = [[NSMutableArray alloc] init];
    [_categoryArray addObject:@"热门"];
    [_categoryArray addObject:@"特色菜"];
    [self configureTableView];
}

- (void)configureTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodCategoryCell class])];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.backgroundColor = GMBgColor;
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodContentCell class])];
    
    //设置多余的seperator
    [self.dataTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.dataTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}

#pragma mark <UITableView>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {
        return _categoryArray.count;
    } else {
        return [(ResFoodClass *)_foodClassArray[section] foodArray].count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _dataTableView) {
        if (_foodClassArray) {
            NSLog(@"section个数为%lu",(unsigned long)_foodClassArray.count);
            return _foodClassArray.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableView) {
        FoodCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCategoryCell class])];
        cell.content = _categoryArray[indexPath.row];
        return cell;
    } else {
        FoodContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodContentCell class])];
        
        ResFoodClass *foodClass = _foodClassArray[indexPath.section];
        _resFood = foodClass.foodArray[indexPath.row];
        [cell.pictureUrl sd_setImageWithURL:[NSURL URLWithString:_resFood.pictureUrl]];
        cell.name.text = _resFood.name;
        cell.sales.text = [NSString stringWithFormat:@"月销量%@", _resFood.sales];
        cell.price.text = [NSString stringWithFormat:@"%@元/份", _resFood.price];
        cell.foodCount = 0;
        cell.minus.enabled = NO;
        [cell.minus addTarget:self action:@selector(cellMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.add addTarget:self action:@selector(cellAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)cellMinusButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodContentCell *cell = (FoodContentCell *)[[button superview] superview];
    if (cell) {
        if (cell.foodCount != 0) {
            if (cell.foodCount == 1) {
                cell.minus.enabled = NO;
            }
            cell.foodCount = cell.foodCount - 1;
            __weak FoodDetailViewController *foodDetailViewController = (FoodDetailViewController *)self.parentViewController;
            if (foodDetailViewController) {
                if (foodDetailViewController.trollyButtonBadgeCount != 0) {
                    foodDetailViewController.trollyButtonBadgeCount = foodDetailViewController.trollyButtonBadgeCount - 1;
                }
            }
        }
    }
}

- (void)cellAddButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodContentCell *cell = (FoodContentCell *)[[button superview] superview];
    if (cell) {
        if (cell.foodCount == 0) {
            cell.minus.enabled = YES;
        }

        cell.foodCount = cell.foodCount + 1;
        __weak FoodDetailViewController *foodDetailViewController = (FoodDetailViewController *)self.parentViewController;
        if (foodDetailViewController) {
            foodDetailViewController.trollyButtonBadgeCount = foodDetailViewController.trollyButtonBadgeCount + 1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:127.0/255.0 blue:14.0/255.0 alpha:0.34];
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(10, 0, 100, 22);
        if (_foodClassArray[section]) {
            title.text = [(ResFoodClass *)_foodClassArray[section] name];
        }
        title.textColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        title.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:title];
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _categoryTableView) {
        return 0;
    } else {
        return 22;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableView) {
        return 48;
    } else {
        return 78;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _categoryTableView) {
        [self.dataTableView scrollToRow:0 inSection:indexPath.row atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
//        _resFoodClass = _foodManager.resFoodClassArray[indexPath.row];
//        _currentFoodClassIndex = indexPath.row;
//        _foodArray = _resFoodClass.foodArray;
//        [_dataTableView reloadData];
    } else {
        _resFood = _foodArray[indexPath.row];
    }
}

// 分割线不靠左补全
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.dataTableView) {
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
}

- (void)updateOrder {
    _foodManager = [FoodManager sharedInstance];
    // 食物类型的数组
    _foodClassArray = _foodManager.resFoodClassArray;
    NSLog(@"foodClassArray%@",_foodClassArray);
    [self.categoryArray removeAllObjects];
    for (ResFoodClass *resFoodClass in _foodClassArray) {
       [_categoryArray addObject:resFoodClass.name];
    }
    // 第一个食物类型
    _resFoodClass = _foodClassArray[0];
    // 该食物类型下的所有食物
    _foodArray = _resFoodClass.foodArray;
    if ([_foodArray count] != 0) {
        _resFoodClass = _foodClassArray[0];
    }
    
//    _foodCountArray = [[NSMutableArray alloc] init];
//    if (_foodClassArray.count != 0) {
//        for (int i = 0; i < _foodClassArray.count; i++) {
//            NSMutableArray *countArray = [[NSMutableArray alloc] init];
//            if ([(ResFoodClass *)_foodClassArray[i] foodArray].count != 0) {
//                for (int j = 0; j < [(ResFoodClass *)_foodClassArray[i] foodArray].count; j++) {
//                    [countArray addObject:[NSNumber numberWithInt:0]];
//                }
//                [_foodCountArray addObject:countArray];
//            }
//        }
//    }
//    _currentFoodClassIndex = 0;
    
    NSLog(@"array是%@",self.foodCountArray);
    [self.categoryTableView reloadData];
    [self.dataTableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

@end
