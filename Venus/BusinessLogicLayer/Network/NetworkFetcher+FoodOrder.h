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
/**
 *  取消订单
 *
 *  @param orderID
 *  @param success
 *  @param failure
 */
+ (void)foodCancelOrderWithOrderID:(long)orderID
                           success:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure;

/**
 *  确认收货
 *
 *  @param orderID
 *  @param storeID
 *  @param success
 *  @param failure
 */
+ (void)foodConfirmOrderWithOrderID:(long)orderID
                            storeID:(long)storeID
                            success:(NetworkFetcherSuccessHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;
/**
 *  申请退款
 *
 *  @param orderID
 *  @param reason
 *  @param success
 *  @param failure
 */
+ (void)foodRefundOrderWithOrderId:(long)orderID
                            reason:(NSString *)reason
                           success:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure;
/**
 *  创建评论
 *
 *  @param orderID
 *  @param deliveryTime
 *  @param foodGrade
 *  @param content
 *  @param storeID
 *  @param pictures
 */
+ (void)foodUserCreateCommentWithOrderId:(long)orderID
                            deliveryTime:(NSInteger)deliveryTime
                               foodGrade:(NSInteger)foodGrade
                                 content:(NSString *)content
                                 storeId:(long)storeID
                                pictures:(NSArray *)pictures
                                 success:(NetworkFetcherSuccessHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure;


@end
