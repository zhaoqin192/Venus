//
//  NetworkFetcher+FoodAddress.h
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@class FoodAddress;

@interface NetworkFetcher (FoodAddress)

/**
 *  获取用户收货地址
 *
 *  @param restaurantID
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherUserFoodAddresWithRestaurantID:(NSString *)restaurantID
                                          success:(NetworkFetcherCompletionHandler)success
                                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  增加用户收货地址
 *
 *  @param foodAddress
 *  @param succes
 *  @param failure
 */
+ (void)addUserFoodAddress:(FoodAddress *)foodAddress
                   success:(NetworkFetcherCompletionHandler)success
                   failure:(NetworkFetcherErrorHandler)failure;

/**
 *  编辑用户收货地址
 *
 *  @param foodAddress
 *  @param success
 *  @param failure
 */
+ (void)EditUserFoodAddress:(FoodAddress *)foodAddress
                    success:(NetworkFetcherCompletionHandler)success
                    failure:(NetworkFetcherErrorHandler)failure;

/**
 *  删除用户收货地址
 *
 *  @param foodAddress
 *  @param success
 *  @param failure
 */
+ (void)DeleteUserFoodAddress:(FoodAddress *)foodAddress
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;
@end
