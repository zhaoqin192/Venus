//
//  SearchResultViewController.m
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultViewModel.h"
#import "MBProgressHUD.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultModel.h"
#import "BrandViewController.h"

@interface SearchResultViewController ()

@property (nonatomic, strong) SearchResultViewModel *viewModel;
@property (nonatomic, strong) UIImageView *promptView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self bindViewModel];
    
    [self configureTable];
    
    
}

- (void)bindViewModel {
    
    self.viewModel = [[SearchResultViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.searchSuccessObject subscribeNext:^(id x) {
        
        @strongify(self)
        [self.tableView reloadData];
        
        if (self.viewModel.searchArray.count == 0) {
            UIImage *image = [UIImage imageNamed:@"loginLogo"];
            
            self.promptView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - image.size.width / 2, self.view.frame.size.height / 2 - image.size.height / 2, image.size.width, image.size.height)];
            
            self.promptView.image = image;
            
            
            [self.view addSubview:self.promptView];
        }
        
    }];
    
    [self.viewModel.searchFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.promptView != nil) {
        [self.promptView removeFromSuperview];
    }
}



- (void)configureTable {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    /*
     -updateSearchResultsForSearchController: is called when the controller is
     being dismissed to allow those who are using the controller they are search
     as the results controller a chance to reset their state. No need to update
     anything if we're being dismissed.
     */
    if (!searchController.active) {
        return;
    }
    
    if (searchController.searchBar.text.length > 0) {
        [self.viewModel searchWithKeyword:searchController.searchBar.text];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultModel *model = [self.viewModel.searchArray objectAtIndex:indexPath.row];
    
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultTableViewCell"];
    
    cell.nameLabel.text = model.name;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultModel *model = [self.viewModel.searchArray objectAtIndex:indexPath.row];
    
    if ([model.type isEqualToNumber:@1]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"brand" object:nil userInfo:@{@"url": [@"/bazaar/mobile/brandShop/" stringByAppendingString:model.identifier]}];
    
    }
    else {
        
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
