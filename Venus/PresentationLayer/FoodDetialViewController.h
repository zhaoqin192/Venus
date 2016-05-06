//
//  FoodDetialViewController.h
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


@interface FoodDetialViewController : UIViewController

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, weak) id<FoodDetailDelegate> delegate;

@end
