//
//  NetworkFetcher+Food.h
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@class FoodClass;

@interface NetworkFetcher (Food)

/**
 *  获取餐厅分类
 *
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherClassWithSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  根据餐厅分类获取餐厅
 *
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherRestaurantWithClass:(FoodClass *)foodClass
                               sort:(NSString *)sort
                               page:(NSString *)page
                            success:(NetworkFetcherSuccessHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取餐厅的菜品和分类
 *
 *  @param restaurantID
 *  @param sort
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherRestaurantListWithID:(NSString *)restaurantID
                                   sort:(NSString *)sort
                                success:(NetworkFetcherCompletionHandler)success
                                failure:(NetworkFetcherErrorHandler)failure;
/**
 *  新的获取餐厅的菜品
 *
 *  @param restaurantID
 *  @param sort
 *  @param success
 *  @param failure
 */
+ (void)newFoodFetcherRestaurantListWithID:(long)restaurantID
                                   sort:(int)sort
                                success:(NetworkFetcherSuccessHandler)success
                                failure:(NetworkFetcherErrorHandler)failure;


/**
 *  获取餐厅评论
 *
 *  @param restaurantID
 *  @param level
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherCommentListWithID:(NSString *)restaurantID
                               level:(NSString *)level
                             success:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取餐厅用户信息
 *
 *  @param restaurantID
 *  @param success
 *  @param failure
 */
+ (void)foodFetcherRestaurantInfoWithID:(NSNumber *)restaurantID
                                success:(NetworkFetcherSuccessHandler)success
                                failure:(NetworkFetcherErrorHandler)failure;

@end
