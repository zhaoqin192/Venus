//
//  FoodOrderViewSectionObject.m
//  Venus
//
//  Created by EdwinZhou on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderViewSectionObject.h"
#import "FoodOrderViewBaseItem.h"

@implementation FoodOrderViewSectionObject

#pragma mark - getters and setters
- (NSString *)headerTitle {
    if (_headerTitle) {
        return _headerTitle;
    } else {
        _headerTitle = @"";
        return _headerTitle;
    }
}

- (NSString *)footerTitle {
    if (_footerTitle) {
        return _footerTitle;
    } else {
        _footerTitle = @"";
        return _footerTitle;
    }
}

- (NSMutableArray *)items {
    if (_items) {
        return _items;
    } else {
        _items = [[NSMutableArray alloc] init];
        return _items;
    }
}

@end
