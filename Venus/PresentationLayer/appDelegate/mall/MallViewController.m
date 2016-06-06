//
//  MallViewController.m
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "MallViewController.h"
#import "MallViewModel.h"
#import "CategoryViewCell.h"
#import "MallCategoryModel.h"
#import "KindViewCell.h"
#import "SectionHeadViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "BrandViewCell.h"
#import "MoreViewCell.h"
#import "KindViewController.h"
#import "MallKindModel.h"
#import "MBProgressHUD.h"
#import "BrandDetailViewController.h"


@interface MallViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (nonatomic, strong) MallViewModel *viewModel;

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物";
    
    if (!self.selectCategory) {
        self.selectCategory = @0;
    }
    
    [self configureTableView];
    
    [self bindViewModel];
    
    [self.viewModel fetchCategory];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [self.viewModel cacheData];
}


- (void)bindViewModel {
    
    self.viewModel = [[MallViewModel alloc] init];

    @weakify(self)
    [self.viewModel.categorySuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.categoryTableView reloadData];
        [self.contentTableView reloadData];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.selectCategory integerValue] inSection:0];
        [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.viewModel.categoryModel = [self.viewModel.categoryArray objectAtIndex:[self.selectCategory integerValue]];
    }];
    
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showKindView" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        UIStoryboard *kind = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
        KindViewController *kindVC = (KindViewController *)[kind instantiateViewControllerWithIdentifier:@"kind"];
        NSDictionary *userInfo = notification.userInfo;
        kindVC.kindModel = userInfo[@"kindModel"];
        @strongify(self)
        [self.navigationController pushViewController:kindVC animated:YES];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showBrandView" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        UIStoryboard *kind = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
        NSDictionary *userInfo = notification.userInfo;
        BrandDetailViewController *brandVC = (BrandDetailViewController *)[kind instantiateViewControllerWithIdentifier:[BrandDetailViewController className]];
        brandVC.storeID = [NSNumber numberWithString:userInfo[@"storeID"]];
        @strongify(self)
        [self.navigationController pushViewController:brandVC animated:YES];
    }];
}

- (void)configureTableView {
    
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    
    //取消多余的seperator
    [self.categoryTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.categoryTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    [self.contentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.contentTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentTableView) {
        
        if (indexPath.section == 0) {
            if (self.viewModel.categoryModel.kindArray.count > 6) {
                return 300;
            }
            else if (self.viewModel.categoryModel.kindArray.count > 3) {
                return 200;
            }
            else if (self.viewModel.categoryModel.kindArray.count > 0) {
                return 100;
            }
            else {
                return 0;
            }
        }
        else if (indexPath.section == 1) {
            
            if (self.viewModel.categoryModel.brandArray.count > 9) {
                return 351;
            }
            else if (self.viewModel.categoryModel.brandArray.count > 6) {
                return 262;
            }
            else if (self.viewModel.categoryModel.brandArray.count > 3) {
                return 173;
            }
            else if (self.viewModel.categoryModel.brandArray.count > 0) {
                return 84;
            }
            else {
                return 0;
            }
            
        }
        return 0;
    }
    else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        return 1;
    }
    else {
        return self.viewModel.categoryArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.contentTableView) {
        
        if (self.viewModel.categoryModel.kindArray.count > 9) {
            return 3;
        }
        else {
            return 2;
        }
    }
    else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.contentTableView) {
        
        if (indexPath.section == 0) {
            KindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KindViewCell className]];
            
            if (self.viewModel.categoryModel.kindArray.count > 9) {
                cell.kindArray = [self.viewModel.categoryModel.kindArray subarrayWithRange:NSMakeRange(0, 9)];
            }
            else {
                cell.kindArray = self.viewModel.categoryModel.kindArray;
            }
            
            [cell.collection reloadData];
            
            return cell;
        }
        else if (indexPath.section == 1) {
            BrandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandViewCell className]];
            
            if (self.viewModel.categoryModel.brandArray.count > 12) {
                cell.brandArray = [self.viewModel.categoryModel.brandArray subarrayWithRange:NSMakeRange(0, 12)];
            }
            else {
                cell.brandArray = self.viewModel.categoryModel.brandArray;
            }
            
            
            [cell.collection reloadData];
            
            return cell;
        }
        else if (indexPath.section == 2) {
            MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoreViewCell className]];
            
            cell.moreArray = [self.viewModel.categoryModel.kindArray subarrayWithRange:NSMakeRange(9, self.viewModel.categoryModel.kindArray.count - 1)];
            
            [cell.collection reloadData];
            
            return cell;
        }
        return nil;
        
    }
    else {
        CategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CategoryViewCell className]];
        MallCategoryModel *model = [self.viewModel.categoryArray objectAtIndex:indexPath.row];
        cell.name.text = model.name;
        
        UIView *backgroundView = [[UIView alloc] init];
        NSInteger xPostion = cell.bounds.size.width / 2;
        NSInteger yPostion = cell.bounds.size.height;
        UIView *redStripe = [[UIView alloc] initWithFrame:CGRectMake(xPostion + 2, yPostion - 2, xPostion, 2)];
        redStripe.backgroundColor = [UIColor colorWithHexString:@"B01C2E"];
        [backgroundView addSubview:redStripe];
        
        backgroundView.backgroundColor = [UIColor whiteColor];
        [cell setSelectedBackgroundView:backgroundView];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.categoryTableView) {
        
        self.viewModel.categoryModel = [self.viewModel.categoryArray objectAtIndex:indexPath.row];
        [self.contentTableView reloadData];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SectionHeadViewCell className]];
    if (section == 0) {
        cell.title.text = @"推荐类目";
    }
    else if (section == 1) {
        cell.title.text = @"推荐品牌";
    }
    else if (section == 2) {
        cell.title.text = @"更多条目";
    }
    
    return cell;    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
