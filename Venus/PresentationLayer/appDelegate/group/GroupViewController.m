//
//  GroupViewController.m
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "GroupViewController.h"
#import "JSDropDownMenu.h"
#import "GroupViewModel.h"
#import "RootTabViewController.h"
#import "GroupCategory.h"
#import "CouponModel.h"
#import "CouponCell.h"
#import "MBProgressHUD.h"
#import "CouponViewController.h"
#import "LoadingCell.h"
#import <UITableView+FDTemplateLayoutCell.h>


@interface GroupViewController ()<UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate>

@property (nonatomic, strong) JSDropDownMenu *menu;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GroupViewModel *viewModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end



@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"团购劵";
    
    [self initTableView];
    [self bindViewModel];
    
    [self.viewModel fetchMenuData];
    [self.viewModel fetchCouponDataWithType:self.viewModel.type sort:self.viewModel.sort page:[NSNumber numberWithInteger:self.viewModel.currentPage]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    NSLog(@"%f", self.view.frame.origin.y);

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [self.viewModel cachedMenuData];
    [self.viewModel cachedCouponData];
    
    NSLog(@"%f", self.view.frame.origin.y);
    
}


- (void)initMenu {
    
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    self.menu.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.menu.indicatorColor = [UIColor colorWithHexString:@"AFAFAF"];
    self.menu.separatorColor = [UIColor colorWithHexString:@"D2D2D2"];
    self.menu.textColor = [UIColor colorWithHexString:@"535353"];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    
}

- (void)initTableView {
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)refreshTableView {
    
    [self.viewModel fetchCouponDataWithType:self.viewModel.type sort:self.viewModel.sort page:@1];
    
}

- (void)loadMore {
    
    [self.viewModel loadMoreCouponDataWithType:self.viewModel.type sort:self.viewModel.sort page:[NSNumber numberWithInteger:++self.viewModel.currentPage]];
    
}

- (void)bindViewModel {
    self.viewModel = [[GroupViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.menuSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self initMenu];
    }];
    
    [self.viewModel.couponSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        [self.tableView reloadData];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.currentPage == self.viewModel.totalPage) {
        return self.viewModel.couponArray.count;
    }
    
    return self.viewModel.couponArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.viewModel.couponArray.count) {
        LoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        [cell.indicator startAnimating];
        return cell;
    }
    
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    
    [self configureCouponCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCouponCell:(CouponCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    CouponModel *model= [self.viewModel.couponArray objectAtIndex:indexPath.row];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
    cell.title.text = model.name;
    cell.price.text = [NSString stringWithFormat:@"%@", model.abstract];
    cell.sale.text = [NSString stringWithFormat:@"已售:%@", model.purchaseNum];
    cell.asPrice.text = [NSString stringWithFormat:@"%.2f元", [model.price floatValue] / 100];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    return self.menu;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.currentPage != self.viewModel.totalPage && indexPath.row == self.viewModel.couponArray.count) {
        [self loadMore];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewModel.currentPage != self.viewModel.totalPage && indexPath.row == self.viewModel.couponArray.count) {
        return 40;
    }
    
    @weakify(self)
    return [tableView fd_heightForCellWithIdentifier:@"CouponCell" configuration:^(CouponCell *cell) {
        @strongify(self)
        [self configureCouponCell:cell atIndexPath:indexPath];
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 45;
    }
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -MenuDelegate

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
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    
    if (column == 0) {
        return self.viewModel.typeArray.count;
    }
    else if (column == 1) {
        return self.viewModel.sortArray.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column {
    
    switch (column) {
        case 0:
            return [[self.viewModel.typeArray objectAtIndex:0] name];
            break;
        case 1:
            return [self.viewModel.sortArray objectAtIndex:0];

            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return [[self.viewModel.typeArray objectAtIndex:indexPath.row] name];
    }
    else {
        return [self.viewModel.sortArray objectAtIndex:indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        self.viewModel.type = [[self.viewModel.typeArray objectAtIndex:indexPath.row] identifier];
        [self.viewModel fetchCouponDataWithType:self.viewModel.type sort:self.viewModel.sort page:@1];
    }
    else {
        switch (indexPath.row) {
            case 0:
                self.viewModel.sort = @"time";
                break;
            case 1:
                self.viewModel.sort = @"price";
                break;
            case 2:
                self.viewModel.sort = @"sale";
                break;
            default:
                break;
        }
        [self.viewModel fetchCouponDataWithType:self.viewModel.type sort:self.viewModel.sort page:@1];
    }
}

#pragma mark -prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"couponIdentifier"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CouponViewController *couponVC = segue.destinationViewController;
        couponVC.couponModel = [self.viewModel.couponArray objectAtIndex:indexPath.row];
    }
    
    
    
}


@end
