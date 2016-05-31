//
//  NewFoodManager.h
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NewFoodManagerUpdateSucceedHandler)();
typedef void(^NewFoodManagerUpdateFailedHandler)(NSString *error);

@interface NewFoodManager : NSObject

+ (NewFoodManager *)sharedInstance;

- (void)updateDataWithStoreID:(NSString *)storeID
                      succeed:(NewFoodManagerUpdateSucceedHandler)success
                       failed:(NewFoodManagerUpdateFailedHandler)fail;

@property (strong, nonatomic) NSArray *foodClassArray;
@property (strong, nonatomic) NSArray *allFoodArray;

@property (copy, nonatomic) NSString *storeID;

@end
