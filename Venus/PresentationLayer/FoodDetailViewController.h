//
//  FoodDetailViewController.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;
@class FoodOrderViewController;

@interface FoodDetailViewController : UIViewController

@property (nonatomic, strong) Restaurant *restaurant;
@property (strong, nonatomic) FoodOrderViewController *orderVC;

@property (assign, nonatomic) NSInteger trollyButtonBadgeCount;

- (void)deleteTrolly;

@end
