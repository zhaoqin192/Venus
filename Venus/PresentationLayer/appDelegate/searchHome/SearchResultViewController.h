//
//  SearchResultViewController.h
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultViewModel;

@interface SearchResultViewController : UITableViewController <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) SearchResultViewModel *viewModel;
@property (nonatomic, strong) UIImageView *promptView;


@end
