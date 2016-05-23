//
//  FoodOrderViewBaseItem.m
//  Venus
//
//  Created by EdwinZhou on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderViewBaseItem.h"
#import "ResFood.h"

@implementation FoodOrderViewBaseItem

- (instancetype)initWithResFood:(ResFood *)resFood {
    if (self = [super init]) {
        if (resFood.pictureUrl) {
            _pictureURL = resFood.pictureUrl;
            _name = resFood.name;
            _soldCount = [resFood.sales integerValue];
            _unitPrice = [resFood.price floatValue];
            _orderCount = 0;
            
        }
    }
    return self;
}

@end
