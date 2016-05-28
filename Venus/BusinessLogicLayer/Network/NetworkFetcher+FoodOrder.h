//
//  NetworkFetcher+FoodOrder.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@class FoodAddress;
@interface NetworkFetcher (FoodOrder)
/**
 *  获得外卖订单
 *
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherUserFoodOrderOnPage:(NSInteger)page
                                success:(NetworkFetcherCompletionHandler)success
                                failure:(NetworkFetcherErrorHandler)failure;


//+ (void)foodCreateOrderWithStoreID:(NSString *)storeID
//                           address:(FoodAddress *)foodAddress
//                            remark:(NSString *)remark
//                                paymentStatus
//                             success:(NetworkFetcherSuccessHandler)success
//                             failure:(NetworkFetcherErrorHandler)failure;
@end
