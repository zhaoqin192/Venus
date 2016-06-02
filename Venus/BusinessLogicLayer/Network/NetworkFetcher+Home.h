//
//  NetworkFetcher+Home.h
//  Venus
//
//  Created by zhaoqin on 4/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (Home)

/**
 *  获取轮播图片
 *
 *  @param success
 *  @param failure
 */
+ (void)homeFetcherLoopPictureWithSuccess:(NetworkFetcherCompletionHandler)success
                                  failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取今日推荐数据
 *
 *  @param success
 *  @param failure
 */
+ (void)homeFetcherRecommmendWithSuccess:(NetworkFetcherCompletionHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取楼层数据
 *
 *  @param success
 *  @param failure
 */
+ (void)homeFetcherListADWithSuccess:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure;


/**
 *  获取今日头条
 *
 *  @param success
 *  @param failure
 */
+ (void)homeFetcherHeadlineArrayWithSuccess:(NetworkFetcherSuccessHandler)success
                                    failure:(NetworkFetcherErrorHandler)failure;

@end
