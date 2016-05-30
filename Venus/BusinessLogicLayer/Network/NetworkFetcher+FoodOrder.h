//
//  NetworkFetcher+FoodOrder.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@class FoodOrder;
@interface NetworkFetcher (FoodOrder)
/**
 *  获得所有外面订单
 *
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherUserFoodOrderOnPage:(NSInteger)page
                                success:(NetworkFetcherSuccessHandler)success
                                failure:(NetworkFetcherErrorHandler)failure;
/**
 *  获得外卖订单详情
 *
 *  @param orderID
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherUserFoodOrderDetailWithID:(NSInteger)orderID
                                     success:(NetworkFetcherSuccessHandler)success
                                     failure:(NetworkFetcherErrorHandler)failure;

/**
 *  创建订单获得orderID
 *
 *  @param order
 *  @param success
 *  @param failure
 */
+ (void)foodCreateOrder:(FoodOrder *)order
                success:(NetworkFetcherSuccessHandler)success
                failure:(NetworkFetcherErrorHandler)failure;

/**
 *  支付宝预支付
 *
 *  @param orderID
 *  @param success
 *  @param failure 
 */
+ (void)foodAlipayWithOrderID:(long)orderID
                      success:(NetworkFetcherSuccessHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;

@end
