//
//  NewFoodManager.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NewFoodManager.h"
#import "NetworkFetcher+Food.h"

@implementation NewFoodManager

+ (NewFoodManager *)sharedInstance{
    static NewFoodManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)updateDataWithStoreID:(NSString *)storeID
                      succeed:(NewFoodManagerUpdateSucceedHandler)success
                       failed:(NewFoodManagerUpdateFailedHandler)fail {

}


- (NSString *)storeID {
    if (!_storeID) {
        _storeID = @"";
    }
    return _storeID;
}

@end
