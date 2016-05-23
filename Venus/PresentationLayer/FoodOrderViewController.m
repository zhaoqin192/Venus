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
#import "NetworkFetcher+Food.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FoodOrderViewSectionObject.h"
#import "FoodOrderViewBaseItem.h"

#import "FoodManager.h"
#import "ResFoodClass.h"
#import "ResFood.h"
#import "ResFood+count.h"


@interface FoodOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation FoodOrderViewController

#pragma mark - init methods
- (instancetype)initWithRestaurantIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _restaurantIdentifier = identifier;
    }
    return self;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_restaurantIdentifier) {
        [NetworkFetcher foodFetcherRestaurantListWithID:_restaurantIdentifier sort:@"2" success:^{
            [self configureSections];
        } failure:^(NSString *error) {
            NSLog(@"获取食物信息失败,错误是：%@",error);
        }];
    }

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _categoryTableView) {
        if (self.sections.count == 0) {
            return 1;
        } else {
            return self.sections.count;
        }
    } else {
        if (self.sections.count > section) {
            FoodOrderViewSectionObject *sectionObject = self.sections[section];
            if (sectionObject.items.count == 0) {
                return 1;
            } else {
                return sectionObject.items.count;
            }
        } else {
            return 1;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _categoryTableView) {
        return 1;
    } else {
        if (self.sections.count == 0) {
            return 1;
        } else {
            return self.sections.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableView) {
        FoodCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCategoryCell class])];
        if (self.sections.count > indexPath.row) {
            cell.content = [(FoodOrderViewSectionObject *)self.sections[indexPath.row] headerTitle];
        } else {
            cell.content = @"";
        }
        return cell;
    } else {
        if (self.sections.count > indexPath.section) {
            FoodContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodContentCell class])];
            FoodOrderViewSectionObject *sectionObject = (FoodOrderViewSectionObject *)self.sections[indexPath.section];
            if (sectionObject.items.count > indexPath.row) {
                cell.baseItem = (FoodOrderViewBaseItem *)sectionObject.items[indexPath.row];
            }
            [cell.minus addTarget:self action:@selector(cellMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.add addTarget:self action:@selector(cellAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.minus.enabled = NO;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:127.0/255.0 blue:14.0/255.0 alpha:0.34];
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(10, 0, 100, 22);
        title.textColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        title.font = [UIFont systemFontOfSize:12.0];
        
        if (self.sections.count > section) {
            title.text = [(FoodOrderViewSectionObject *)self.sections[section] headerTitle];
        }
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

#pragma mark - event response
- (void)cellMinusButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    FoodContentCell *cell = (FoodContentCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    
    if (cell) {
        if (cell.foodCount != 0) {
            // 控制减button的可用性
            if (cell.foodCount == 1) {
                cell.minus.enabled = NO;
            }
            
            // 减少cell上的数量
            FoodOrderViewSectionObject *sectionObject = (FoodOrderViewSectionObject *)self.sections[indexPath.section];
            FoodOrderViewBaseItem *baseItem = (FoodOrderViewBaseItem *)sectionObject.items[indexPath.row];
            baseItem.orderCount = baseItem.orderCount - 1;
            cell.foodCount = baseItem.orderCount;
            // 改变parentController
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
    FoodContentCell *cell = (FoodContentCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [self.dataTableView indexPathForCell:cell];
    if (cell) {
        if (cell.foodCount == 0) {
            cell.minus.enabled = YES;
        }
        
        FoodOrderViewSectionObject *sectionObject = (FoodOrderViewSectionObject *)self.sections[indexPath.section];
        FoodOrderViewBaseItem *baseItem = (FoodOrderViewBaseItem *)sectionObject.items[indexPath.row];
        baseItem.orderCount = baseItem.orderCount + 1;
        cell.foodCount = baseItem.orderCount;
        
        __weak FoodDetailViewController *foodDetailViewController = (FoodDetailViewController *)self.parentViewController;
        if (foodDetailViewController) {
            foodDetailViewController.trollyButtonBadgeCount = foodDetailViewController.trollyButtonBadgeCount + 1;
        }
    }
}

#pragma mark - private methods


#pragma mark - getters and setters

- (NSMutableArray *)sections {
    if (_sections) {
        return _sections;
    } else {
        _sections = [[NSMutableArray alloc] init];
        return _sections;
    }
}

- (void)configureSections {
    FoodManager *foodManager = [FoodManager sharedInstance];
    NSMutableArray *foodClassArray = foodManager.resFoodClassArray;
    for (ResFoodClass *resFoodClass in foodClassArray) {
        FoodOrderViewSectionObject *sectionObject = [[FoodOrderViewSectionObject alloc] init];
        sectionObject.headerTitle = resFoodClass.name;
        for (ResFood *food in resFoodClass.foodArray) {
            FoodOrderViewBaseItem *baseItem = [[FoodOrderViewBaseItem alloc] initWithResFood:food];
            [sectionObject.items addObject:baseItem];
        }
        [self.sections addObject:sectionObject];
    }
    [self.dataTableView reloadData];
    [self.categoryTableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

@end
