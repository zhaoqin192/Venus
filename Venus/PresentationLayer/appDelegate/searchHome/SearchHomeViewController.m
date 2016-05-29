//
//  SearchHomeViewController.m
//  Venus
//
//  Created by zhaoqin on 5/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchHomeViewController.h"
#import "MBProgressHUD.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultViewController.h"
#import "SearchHotCollectionViewCell.h"
#import "SearchHotTableViewCell.h"
#import "BrandViewController.h"

@interface SearchHomeViewController ()
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the search results view controller and use it for the UISearchController.
    SearchResultViewController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewControllerStoryboardIdentifier"];
    
    // Create the search controller and make it perform the results updating.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = searchResultsController;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    /*
     Configure the search controller's search bar. For more information on how to configure
     search bars, see the "Search Bar" group under "Search".
     */
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.placeholder = NSLocalizedString(@"搜索", nil);
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:GMBrownColor];
    
//    self.searchController.searchBar.tintColor = GMBrownColor;
//    self.searchController.searchBar.barTintColor = GMBrownColor;
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:GMBrownColor, NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]}];

    
    // Include the search bar within the navigation bar.
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self onClickEvent];
    
}

- (void)onClickEvent {
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"selectHotSearch" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         NSDictionary *userInfo = notification.userInfo;
         @strongify(self)
         self.searchController.searchBar.text = userInfo[@"hotSearch"];
         self.searchController.active = YES;
         
     }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"brand" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        UIStoryboard *kind = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
        BrandViewController *brandVC = (BrandViewController *)[kind instantiateViewControllerWithIdentifier:@"brand"];
        brandVC.detailURL = userInfo[@"url"];
        
        [self.navigationController pushViewController:brandVC animated:YES];
        
    }];
    
}


- (void)configureTable {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SearchHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHotTableViewCell"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 132;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

@end
