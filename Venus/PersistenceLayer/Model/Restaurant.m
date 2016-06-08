//
//  Restaurant.m
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}
- (NSString *)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}
- (NSString *)pictureUrl {
    if (!_pictureUrl) {
        _pictureUrl = @"";
    }
    return _pictureUrl;
}
- (NSString *)sales {
    if (!_sales) {
        _sales = @"";
    }
    return _sales;
}
- (NSString *)basePrice {
    if (!_basePrice) {
        _basePrice = @"";
    }
    return _basePrice;
}
- (NSString *)packFee {
    if (!_packFee) {
        _packFee = @"";
    }
    return _packFee;
}
- (NSString *)costTime {
    if (!_costTime) {
        _costTime = @"";
    }
    return _costTime;
}
- (NSString *)describer {
    if (!_describer) {
        _describer = @"";
    }
    return _describer;
}


@end
