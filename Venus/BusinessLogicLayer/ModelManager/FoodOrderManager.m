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
    [NetworkFetcher foodFetcherUserFoodOrderOnPage:1 success:^(NSDictionary *response) {
        // 装填数据
        NSDictionary *dic = response;
        if ([dic[@"errCode"] isEqualToNumber:@0]) {
            [TakeAwayOrder mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"goodsDetail":@"TakeAwayOrderGood"
                         };
            }];
            [TakeAwayOrder mj_objectWithKeyValues:dic];
            NSLog(@"订单状态是");
            succeedHandler();
        } else {
            
            failedHander(dic[@"msg"]);
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

@end
