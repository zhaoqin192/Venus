//
//  ResFood.m
//  Venus
//
//  Created by zhaoqin on 5/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "ResFood.h"
#import "FoodGood.h"

@implementation ResFood

- (instancetype)initWithFoodGood:(FoodGood *)foodGood {
    self = [super init];
    if (self) {
        _identifier = [NSString stringWithFormat:@"%li",(long)foodGood.id];
        _classID = [NSString stringWithFormat:@"%li",(long)foodGood.cat_id];
        _name = foodGood.name;
        _price = [NSString stringWithFormat:@"%f",foodGood.sale_price];
        _sales = [NSString stringWithFormat:@"%li",(long)foodGood.sales];
        _pictureUrl = foodGood.icon;
        
        _store_id = [NSString stringWithFormat:@"%li",(long)foodGood.store_id];
        _create_time = [NSString stringWithFormat:@"%li",(long)foodGood.create_time];
        _stock = [NSString stringWithFormat:@"%li",(long)foodGood.stock];
        _state = [NSString stringWithFormat:@"%li",(long)foodGood.state];
        _oldPrice = [NSString stringWithFormat:@"%f",foodGood.price];
        _goodDescription = foodGood.goodDescription;
    }
    return self;
}

@end
