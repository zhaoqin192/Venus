//
//  FoodOrderViewBaseItem.m
//  Venus
//
//  Created by EdwinZhou on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderViewBaseItem.h"
#import "ResFood.h"
#import "TakeAwayOrderGood.h"

@implementation FoodOrderViewBaseItem

- (instancetype)initWithResFood:(ResFood *)resFood {
    if (self = [super init]) {
        if (resFood.pictureUrl) {
            _pictureURL = resFood.pictureUrl;
            _name = resFood.name;
            _soldCount = [resFood.sales integerValue];
            _unitPrice = [resFood.price floatValue] / 100.0;
            _orderCount = 0;
            _identifier = resFood.identifier;
        }
    }
    return self;
}

- (instancetype)initWithTakeAwayOrderGood:(TakeAwayOrderGood *)orderGood {
    if (self = [super init]) {
        _identifier = [NSString stringWithFormat:@"%li",orderGood.goodsId];
        _pictureURL = orderGood.icon;
        _name = orderGood.goodsName;
        _soldCount = 0;
        _unitPrice = orderGood.price / 100;
        _orderCount = orderGood.num;
    }
    return self;
}

@end
