//
//  NetworkFetcher+User.h
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher.h"

@interface NetworkFetcher (User)

/**
 *  手机号登陆
 *
 *  @param account
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)userLoginWithAccount:(NSString *)account
                     password:(NSString *)password
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;

/**
 *  QQ登录授权
 *
 *  @param success
 *  @param failure
 */
+ (void)userQQLoginWithSuccess:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure;


+ (void)userQQLoginCallBackWith:(NSString *)code
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure;

///**
// *  微信登录授权
// *
// *  @param success
// *  @param failure 
// */
//+ (void)userLoginWithWeiXinSuccess:(NetworkFetcherCompletionHandler)success
//                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取token
 *
 *  @param code     授权之后返回的code
 *  @param success
 *  @param failure
 */
+ (void)userFetchAccessTokenWithCode:(NSString *)code
                             success:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取用户信息
 *
 *  @param token
 *  @param openID
 *  @param success
 *  @param faiure
 */
+ (void)userFetchUserInfoWithToken:(NSString *)token
                            openID:(NSString *)openID
                           Success:(NetworkFetcherCompletionHandler)success
                           failure:(NetworkFetcherErrorHandler)faiure;

/**
 *  绑定微信号
 *
 *  @param openID
 *  @param name
 *  @param sex
 *  @param avatar
 *  @param account
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)userBindWeChatWithOpenID:(NSString *)openID
                            name:(NSString *)name
                             sex:(NSNumber *)sex
                          avatar:(NSString *)avatar
                         account:(NSString *)account
                        password:(NSString *)password
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure;

/**
 *  判断微信号是否绑定
 *
 *  @param openID
 *  @param success
 *  @param failure 
 */
+ (void)userWeChatIsBoundWithOpenID:(NSString *)openID
                              token:(NSString *)token
                            success:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

@end
