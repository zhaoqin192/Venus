//
//  FoodAddress.m
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddress.h"

@implementation FoodAddress

#pragma mark - getters and setters
- (NSString *)linkmanName {
    if (!_linkmanName) {
        _linkmanName = @"";
    }
    return _linkmanName;
}

- (NSString *)address {
    if (!_address) {
        _address = @"";
    }
    return _address;
}

- (NSString *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = @"";
    }
    return _phoneNumber;
}

@end
