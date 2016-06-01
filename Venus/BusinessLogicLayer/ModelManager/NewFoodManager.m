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
    [NetworkFetcher newFoodFetcherRestaurantListWithID:[storeID longValue] sort:1 success:^(NSDictionary *response) {
        NSLog(@"返回的结果是%@",response);
    } failure:^(NSString *error) {
        
    }];

}


- (NSString *)storeID {
    if (!_storeID) {
        _storeID = @"";
    }
    return _storeID;
}

@end
