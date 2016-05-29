//
//  MallBrandModel.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "MallBrandModel.h"

@implementation MallBrandModel

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.pictureURL forKey:@"pictureURL"];
    [coder encodeObject:self.detailURL forKey:@"detailURL"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    if (self) {
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.pictureURL = [coder decodeObjectForKey:@"pictureURL"];
        self.detailURL = [coder decodeObjectForKey:@"detailURL"];
    }
    return self;
    
}

@end
