//
//  FoodForOrdering.h
//  Venus
//
//  Created by EdwinZhou on 16/5/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResFood;

@interface FoodForOrdering : NSObject

@property (copy, nonatomic) NSString *foodName;
@property (assign, nonatomic) NSInteger foodCount;
@property (assign, nonatomic) CGFloat foodUnitPrice;
@property (assign, nonatomic) CGFloat foodTotalPrice;

- (instancetype)initWithResFood:(ResFood *)resFood;

@end
