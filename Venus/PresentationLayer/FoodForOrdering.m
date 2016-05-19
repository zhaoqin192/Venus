//
//  FoodForOrdering.m
//  Venus
//
//  Created by EdwinZhou on 16/5/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodForOrdering.h"
#import "ResFood.h"

@implementation FoodForOrdering

- (instancetype)initWithResFood:(ResFood *)resFood {
    if (self = [super init]) {
        if (resFood.name) {
            self.foodName = resFood.name;
        }
        if (resFood.price) {
            self.foodUnitPrice = [resFood.price floatValue];
        }
        self.foodCount = 0;
        self.foodTotalPrice = 0.0;
    }
    return self;
}

- (void)setFoodCount:(NSInteger)foodCount {
    if (foodCount >= 0) {
        _foodCount = foodCount;
        _foodTotalPrice = foodCount * _foodUnitPrice;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p, %@>",
            [self class],
            self,
            @{@"foodName:":_foodName,
              @"foodCount":[NSString stringWithFormat:@"%li",(long)_foodCount ],
              @"foodUnitPrice":[NSString stringWithFormat:@"%f",_foodUnitPrice],
              @"foodTotalPrice":[NSString stringWithFormat:@"%f",_foodTotalPrice]
              }
            ];
}

@end
