//
//  CouponModel.m
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.purchaseNum forKey:@"purchaseNum"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeObject:self.asPrice forKey:@"asPrice"];
    [coder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.abstract forKey:@"abstract"];
    [coder encodeObject:self.startTime forKey:@"startTime"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.phone forKey:@"phone"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    if (self) {
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.purchaseNum = [coder decodeObjectForKey:@"purchaseNum"];
        self.price = [coder decodeObjectForKey:@"price"];
        self.asPrice = [coder decodeObjectForKey:@"asPrice"];
        self.pictureUrl = [coder decodeObjectForKey:@"pictureUrl"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.abstract = [coder decodeObjectForKey:@"abstract"];
        self.startTime = [coder decodeObjectForKey:@"startTime"];
        self.endTime = [coder decodeObjectForKey:@"endTime"];
        self.phone = [coder decodeObjectForKey:@"phone"];
    }
    return self;
    
}

@end
