//
//  FoodManager.m
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "FoodManager.h"

@implementation FoodManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.foodClassArray = [[NSMutableArray alloc] init];
        self.resFoodClassArray = [[NSMutableArray alloc] init];
        self.foodArray = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (FoodManager *)sharedInstance {
    static FoodManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FoodManager alloc] init];
    });
    return sharedInstance;
}


@end
