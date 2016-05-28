//
//  NetworkFetcher+FoodOrder.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

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

@end
