//
//  FoodOrderViewBaseItem.h
//  Venus
//
//  Created by EdwinZhou on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResFood;
@class TakeAwayOrderGood;

@interface FoodOrderViewBaseItem : NSObject

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *pictureURL;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger soldCount;
@property (assign, nonatomic) CGFloat unitPrice;
@property (assign, nonatomic) NSInteger orderCount;

- (instancetype)initWithResFood:(ResFood *)resFood;

- (instancetype)initWithTakeAwayOrderGood:(TakeAwayOrderGood *)orderGood;

@end
