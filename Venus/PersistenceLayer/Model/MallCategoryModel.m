//
//  MallCategoryModel.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "MallCategoryModel.h"

@implementation MallCategoryModel

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.brandArray forKey:@"brandArray"];
    [coder encodeObject:self.kindArray forKey:@"kindArray"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.brandArray = [coder decodeObjectForKey:@"brandArray"];
        self.kindArray = [coder decodeObjectForKey:@"kindArray"];
    }
    return self;
}

@end
