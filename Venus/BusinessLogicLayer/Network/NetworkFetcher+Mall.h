//
//  NetworkFetcher+Mall.h
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (Mall)

/**
 *  获取商城首页分类列表
 *
 *  @param success
 *  @param failure
 */
+ (void)mallGetCategoryWithSuccess:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取分类商品列表
 *
 *  @param identifier
 *  @param page
 *  @param capacity
 *  @param sort
 *  @param success
 *  @param failure
 */
+ (void)mallGetKindArrayWithIdentifier:(NSString *)identifier
                                  page:(NSNumber *)page
                              capacity:(NSNumber *)capacity
                                  sort:(NSNumber *)sort
                               success:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure;

/**
 *  商城首页搜索框搜索匹配接口
 *
 *  @param keywords
 *  @param success
 *  @param failure
 */
+ (void)mallSearchWithKeywords:(NSString *)keywords
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

@end
