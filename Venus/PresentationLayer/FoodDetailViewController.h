//
//  FoodDetailViewController.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@protocol FoodDetailDelegate <NSObject>

- (void)updateOrder;

@end


@interface FoodDetailViewController : UIViewController

@property (nonatomic, strong) Restaurant *restaurant;
@property (assign, nonatomic) NSInteger trollyButtonBadgeCount;
@property (nonatomic, weak) id<FoodDetailDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *foodArray;

@end
