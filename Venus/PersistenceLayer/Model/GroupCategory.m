//
//  GroupCategory.m
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "GroupCategory.h"

@implementation GroupCategory

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    
    return self;
    
}


@end
