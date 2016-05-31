//
//  FoodOrderManager.m
//  Venus
//
//  Created by EdwinZhou on 16/5/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderManager.h"
#import "NetworkFetcher+FoodOrder.h"
#import "TakeAwayOrder.h"

@implementation FoodOrderManager

+ (FoodOrderManager *)sharedInstance{
    static FoodOrderManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)updateOrderSucceed:(FoodOrderManagerUpdateSucceedHandler)succeedHandler
                    failed:(FoodOrderManagerUpdateFailedHandler)failedHander {
    [NetworkFetcher foodFetcherUserFoodOrderOnPage:0 success:^(NSDictionary *response) {
        // 装填数据
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            NSArray *array = (NSArray *)response[@"data"];
            [TakeAwayOrder mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"goodsDetail":@"TakeAwayOrderGood"
                         };
            }];
            [self.orderArray removeAllObjects];
            [self.waitingEvalutationOrderArray removeAllObjects];
            [self.refundOrderArray removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                NSLog(@"array%@",array[i]);
                TakeAwayOrder *order = [TakeAwayOrder mj_objectWithKeyValues:(NSDictionary *)array[i]];
                [self.orderArray addObject:order];
                if (order.refundState != -1) {
                    [self.refundOrderArray addObject:order];
                }
                if (order.state == 4) {
                    [self.waitingEvalutationOrderArray addObject:order];
                }
            }
            
            
//            NSLog(@"订单数量是%li",(long)self.orderArray.count);
//            NSLog(@"待评价订单数量是%li",(long)self.waitingEvalutationOrderArray.count);
//            NSLog(@"退款订单数量是%li",(long)self.refundOrderArray.count);
            succeedHandler();
        } else {
            
            failedHander(response[@"msg"]);
        }
        
    } failure:^(NSString *error) {
        NSLog(@"网络异常错误是%@",error);
    }];
}

- (void)addDataOnPage:(NSInteger)page
              succeed:(FoodOrderManagerUpdateSucceedHandler)succeedHandler
               failed:(FoodOrderManagerUpdateFailedHandler)failedHander {
    [NetworkFetcher foodFetcherUserFoodOrderOnPage:page success:^(NSDictionary *response) {
        // 装填数据
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            NSArray *array = (NSArray *)response[@"data"];
            [TakeAwayOrder mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"goodsDetail":@"TakeAwayOrderGood"
                         };
            }];
            if (array.count == 0) {
                failedHander(@"没有更多数据了");
            } else {
                for (int i = 0; i < array.count; i++) {
                    NSLog(@"array%@",array[i]);
                    TakeAwayOrder *order = [TakeAwayOrder mj_objectWithKeyValues:(NSDictionary *)array[i]];
                    [self.orderArray addObject:order];
                    if (order.refundState != -1) {
                        [self.refundOrderArray addObject:order];
                    }
                    if (order.state == 4) {
                        [self.waitingEvalutationOrderArray addObject:order];
                    }
                }
                succeedHandler();
            }
        } else {
            
            failedHander(response[@"msg"]);
        }
        
    } failure:^(NSString *error) {
        NSLog(@"网络异常错误是%@",error);
    }];
}

#pragma mark - getters and setters

- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [[NSMutableArray alloc] init];
    }
    return _orderArray;
}

- (NSMutableArray *)waitingEvalutationOrderArray {
    if (!_waitingEvalutationOrderArray) {
        _waitingEvalutationOrderArray = [[NSMutableArray alloc] init];
    }
    return _waitingEvalutationOrderArray;
}

- (NSMutableArray *)refundOrderArray {
    if (!_refundOrderArray) {
        _refundOrderArray = [[NSMutableArray alloc] init];
    }
    return _refundOrderArray;
}

@end
