//
//  ResFood.h
//  Venus
//
//  Created by zhaoqin on 5/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FoodGood;

@interface ResFood : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *sales;
@property (nonatomic, copy) NSString *pictureUrl;

@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *oldPrice;
@property (nonatomic, copy) NSString *goodDescription;

- (instancetype)initWithFoodGood:(FoodGood *)foodGood;

@end
