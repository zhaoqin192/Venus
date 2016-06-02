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
#import "BeautifulDetailViewController.h"
#import "SearchResultViewModel.h"

@interface SearchHomeViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *searchResultsController;
@end

@implementation SearchHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the search results view controller and use it for the UISearchController.
    self.searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewControllerStoryboardIdentifier"];
    
    // Create the search controller and make it perform the results updating.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    self.searchController.searchResultsUpdater = self.searchResultsController;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    /*
     Configure the search controller's search bar. For more information on how to configure
     search bars, see the "Search Bar" group under "Search".
     */
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.placeholder = NSLocalizedString(@"搜索", nil);
    
    self.searchController.searchBar.delegate = self;
    
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
    searchField.textColor = GMBrownColor;

    
    // Include the search bar within the navigation bar.
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self onClickEvent];
 
    
    [self configureTable];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchResultsController.viewModel.searchArray removeAllObjects];
    [self.searchResultsController.tableView reloadData];
    
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
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"beauty" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         NSDictionary *userInfo = notification.userInfo;
         @strongify(self)
         BeautifulDetailViewController *vc = [[BeautifulDetailViewController alloc] init];
         vc.shopId = [[NSNumber numberWithString:userInfo[@"shopID"]] integerValue];
         [self.navigationController pushViewController:vc animated:YES];
         
     }];
    
}


- (void)configureTable {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
//}

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
    
    return CGFLOAT_MIN;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

@end
