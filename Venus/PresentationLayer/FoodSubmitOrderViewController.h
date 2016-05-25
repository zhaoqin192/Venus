//
//  FoodSubmitOrderViewController.h
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodSubmitOrderViewController : UIViewController

@property (copy, nonatomic) NSString *restaurantName;
@property (copy, nonatomic) NSMutableArray *foodArray;
@property (assign, nonatomic) CGFloat shippingFee;

@end
