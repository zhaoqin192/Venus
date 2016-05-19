//
//  ResFood+count.m
//  Venus
//
//  Created by EdwinZhou on 16/5/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ResFood+count.h"

NSString *const ResFood_orderCountKey = @"ResFood_orderCountKey";

@implementation ResFood (count)

@dynamic orderCount;

- (NSInteger)orderCount {
    NSNumber *number = objc_getAssociatedObject(self, &ResFood_orderCountKey);
    return number.integerValue;
}

- (void)setOrderCount:(NSInteger)orderCount {
    NSNumber *number = [NSNumber numberWithInteger:orderCount];
    objc_setAssociatedObject(self, &ResFood_orderCountKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
