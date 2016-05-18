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
        return self.categoryArray.count;
    } else {
        return _foodArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        FoodCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCategoryCell class])];
        cell.content = self.categoryArray[indexPath.row];
                
        return cell;
    } else {
        FoodContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodContentCell class])];
        _resFood = _foodArray[indexPath.row];
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
        NSLog(@"cell不为空！");
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
        NSLog(@"cell就是不为空！");
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        return 48;
    } else {
        return 78;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _categoryTableView) {
        _resFoodClass = _foodManager.resFoodClassArray[indexPath.row];
        _foodArray = _resFoodClass.foodArray;
        [_dataTableView reloadData];
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
    _foodClassArray = _foodManager.resFoodClassArray;
    [self.categoryArray removeAllObjects];
    for (ResFoodClass *resFoodClass in _foodClassArray) {
       [_categoryArray addObject:resFoodClass.name];
    }
    _resFoodClass = _foodClassArray[0];
    _foodArray = _resFoodClass.foodArray;
    if ([_foodArray count] != 0) {
        _resFoodClass = _foodClassArray[0];
    }
    
//    self.foodCountArray = [[NSMutableArray alloc] init];
//    if (_foodClassArray.count != 0) {
//        for (int i = 0; i < _foodClassArray.count; i++) {
//            NSMutableArray *foodCount = [[NSMutableArray alloc] init];
//            if (_foodClassArray[i].foodArray.count) {
//                for (int j = 0; j < _foodArray.count; j++) {
//                    [foodCount addObject:[NSNumber numberWithInt:0]];
//                }
//            }
//            [self.foodCountArray addObject:foodCount];
//        }
//    }
    
    NSLog(@"array是%@",self.foodCountArray);
    [_categoryTableView reloadData];
    [_dataTableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

@end
