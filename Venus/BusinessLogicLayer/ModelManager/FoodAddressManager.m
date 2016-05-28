//
//  FoodAddressManager.m
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddressManager.h"

@implementation FoodAddressManager

+ (FoodAddressManager *)sharedInstance{
    static FoodAddressManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _foodAddressArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
