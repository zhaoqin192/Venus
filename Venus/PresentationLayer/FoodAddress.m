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

//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@: @p, %@>",
//            [self class],
//            self,
//            @{
//              @"联系地址ID":@(_addressID),
//              @"联系人姓名":_linkmanName,
//              @"收货地址":_address,
//              @"电话号码":_phoneNumber}
//            ];
//}
@end
