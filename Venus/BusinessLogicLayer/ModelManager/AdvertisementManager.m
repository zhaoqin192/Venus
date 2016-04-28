//
//  AdvertisementManager.m
//  Venus
//
//  Created by zhaoqin on 4/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "AdvertisementManager.h"

@implementation AdvertisementManager

- (instancetype)init {
    self = [super init];
    self.advertisementArray = [[NSMutableArray alloc] init];
    return self;
}

+ (AdvertisementManager *)sharedInstance {
    static AdvertisementManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AdvertisementManager alloc] init];
    });
    return sharedInstance;
}


@end
