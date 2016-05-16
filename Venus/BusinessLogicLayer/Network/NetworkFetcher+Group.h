//
//  NetworkFetcher+Group.h
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (Group)

/**
 *  分类列表接口
 *
 *  @param success
 *  @param failure
 */
+ (void)groupFetchMenuDataWithSuccess:(NetworkFetcherSuccessHandler)success
                              failure:(NetworkFetcherErrorHandler)failure;

/**
 *  团购劵列表接口(选取特定种类）
 *
 *  @param type
 *  @param sort
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)groupFetchCouponsWithType:(NSString *)type
                             sort:(NSString *)sort
                             page:(NSNumber *)page
                         capacity:(NSNumber *)capacity
                          success:(NetworkFetcherSuccessHandler)success
                          failure:(NetworkFetcherErrorHandler)failure;

//+ (void)groupFetchCouponDetailWith

@end
