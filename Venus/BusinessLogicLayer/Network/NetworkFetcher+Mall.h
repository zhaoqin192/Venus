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
 *  @param page
 *  @param capacity
 *  @param success
 *  @param failure
 */
+ (void)mallSearchWithKeywords:(NSString *)keywords
                          page:(NSNumber *)page
                      capacity:(NSNumber *)capacity
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取商户评论列表
 *
 *  @param storeID
 *  @param page
 *  @param capacity
 *  @param success
 *  @param failure
 */
+ (void)mallFetchCommentWithStoreID:(NSNumber *)storeID
                               page:(NSNumber *)page
                           capacity:(NSNumber *)capacity
                            success:(NetworkFetcherSuccessHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取品牌详情接口
 *
 *  @param storeID
 *  @param success
 *  @param failure
 */
+ (void)mallFetchDetailWithStoreID:(NSNumber *)storeID
                           success:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取品牌所有商品的接口
 *
 *  @param storeID
 *  @param page
 *  @param capacity
 *  @param success
 *  @param failure
 */
+ (void)mallFetchAllKindsWithStoreID:(NSNumber *)storeID
                                page:(NSNumber *)page
                            capacity:(NSNumber *)capacity
                             success:(NetworkFetcherSuccessHandler)success
                             failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取某个商品的详情
 *
 *  @param identifier
 *  @param success
 *  @param failure
 */
+ (void)mallFetchKindDetailWithID:(NSNumber *)identifier
                          success:(NetworkFetcherSuccessHandler)success
                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  品牌评论
 *
 *  @param storeID
 *  @param content
 *  @param success
 *  @param failure
 */
+ (void)mallSendCommentWithStoreID:(NSNumber *)storeID
                           content:(NSString *)content
                           success:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure;

@end
