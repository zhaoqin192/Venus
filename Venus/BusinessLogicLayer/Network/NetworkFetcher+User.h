//
//  NetworkFetcher+User.h
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (User)


+ (void)userLoginWithAccount:(NSString *)account
                     password:(NSString *)password
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;

+ (void)userQQLoginWithSuccess:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure;

+ (void)userQQLoginCallBackWith:(NSString *)code
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure;

+ (void)userLoginWithWeiXinSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

@end
