//
//  FoodOrderManager.h
//  Venus
//
//  Created by EdwinZhou on 16/5/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FoodOrderManagerUpdateSucceedHandler)();
typedef void(^FoodOrderManagerUpdateFailedHandler)(NSString *error);

@interface FoodOrderManager : NSObject

@property (strong, nonatomic) NSMutableArray *orderArray;
@property (strong, nonatomic) NSMutableArray *waitingEvalutationOrderArray;
@property (strong, nonatomic) NSMutableArray *refundOrderArray;

+ (FoodOrderManager *)sharedInstance;

- (void)updateOrderSucceed:(FoodOrderManagerUpdateSucceedHandler)succeedHandler
                    failed:(FoodOrderManagerUpdateFailedHandler)failedHander;

- (void)addDataOnPage:(NSInteger)page
              succeed:(FoodOrderManagerUpdateSucceedHandler)succeedHandler
               failed:(FoodOrderManagerUpdateFailedHandler)failedHander;

@end
