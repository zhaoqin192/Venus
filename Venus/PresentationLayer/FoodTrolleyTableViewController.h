//
//  FoodTrolleyTableViewController.h
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTrolleyTableViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *foodArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
