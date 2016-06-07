//
//  FoodGood.h
//  Venus
//
//  Created by EdwinZhou on 16/6/6.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodGood : NSObject

@property (assign, nonatomic) long id;
@property (assign, nonatomic) long store_id;
@property (assign, nonatomic) long cat_id;
@property (assign, nonatomic) long create_time;
@property (assign, nonatomic) int stock;
@property (assign, nonatomic) int sales;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat sale_price;
@property (copy, nonatomic) NSString *goodDescription;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;

@end
