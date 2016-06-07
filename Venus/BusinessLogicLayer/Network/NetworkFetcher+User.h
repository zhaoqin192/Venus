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
                     success:(void (^)(NSDictionary *response))success
                     failure:(NetworkFetcherErrorHandler)failure;

/**
 *  QQ登录授权
 *
 *  @param success
 *  @param failure
 */
+ (void)userQQLoginWithSuccess:(NetworkFetcherCompletionHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

/**
 *  获取QQ用户信息
 *
 *  @param token
 *  @param openID
 */
+ (void)userFetchUserInfoWithQQToken:(NSString *)token
                              openID:(NSString *)openID
                             success:(void (^)(NSDictionary *userInfo))success
                             failure:(NetworkFetcherErrorHandler)failure;

/**
 *  判断QQ是否绑定
 *
 *  @param openID
 *  @param success
 *  @param failure
 */
+ (void)userQQIsBoundWithOpenID:(NSString *)openID
                          token:(NSString *)token
                        success:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure;

/**
 *  绑定QQ号
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
+ (void)userBindQQWithOpenID:(NSString *)openID
                        name:(NSString *)name
                      avatar:(NSString *)avatar
                     account:(NSString *)phone
                    password:(NSString *)password
                       token:(NSString *)token
                      gender:(NSString *)gender
                     success:(NetworkFetcherSuccessHandler)success
                     failure:(NetworkFetcherErrorHandler)failure;

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
 *  WeChat使用token及openID获取用户信息
 *
 *  @param token
 *  @param openID
 *  @param success
 *  @param faiure
 */
+ (void)userFetchUserInfoWithWeChatToken:(NSString *)token
                                  openID:(NSString *)openID
                                 Success:(void (^)(NSDictionary *userInfo))success
                                 failure:(NetworkFetcherErrorHandler)faiure;

/**
 *  注册手机号绑定微信
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
                         account:(NSString *)phone
                        password:(NSString *)password
                           token:(NSString *)token
                         unionID:(NSString *)unionID
                         success:(NetworkFetcherSuccessHandler)success
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

/**
 *  验证手机号
 *
 *  @param number
 *  @param success
 *  @param failure
 */
+ (void)userCheckMobileWithNumber:(NSString *)number
                          success:(NetworkFetcherCompletionHandler)success
                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  注册用户
 *
 *  @param phone
 *  @param password
 *  @param code
 *  @param success
 *  @param failure
 */
+ (void)userRegisterWithPhone:(NSString *)phone
                     password:(NSString *)password
                        token:(NSString *)token
                      success:(NetworkFetcherSuccessHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;

/**
 *  发送验证码
 *
 *  @param number
 *  @param success
 *  @param failure
 */
+ (void)userSendCodeWithNumber:(NSString *)number
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

/**
 *  检验短信验证码
 *
 *  @param code
 *  @param number
 *  @param success
 *  @param failure
 */
+ (void)userValidateSMS:(NSString *)code
                 mobile:(NSString *)number
                success:(void (^)(NSDictionary *response))success
                failure:(NetworkFetcherErrorHandler)failure;

/**
 *  微信绑定已有手机号
 *
 *  @param phone
 *  @param password
 *  @param openID
 *  @param name
 *  @param sex
 *  @param avatar
 *  @param unionID
 *  @param success
 *  @param failure
 */
+ (void)userWechatBindWithPhone:(NSString *)phone
                       password:(NSString *)password
                         openID:(NSString *)openID
                           name:(NSString *)name
                            sex:(NSNumber *)sex
                         avatar:(NSString *)avatar
                        unionID:(NSString *)unionID
                        success:(NetworkFetcherSuccessHandler)success
                        failure:(NetworkFetcherErrorHandler)failure;

/**
 *  QQ绑定已有手机号
 *
 *  @param phone
 *  @param password
 *  @param openID
 *  @param name
 *  @param gender
 *  @param avatar
 *  @param success
 *  @param failure
 */
+ (void)userQQBindWithPhone:(NSString *)phone
                   password:(NSString *)password
                     openID:(NSString *)openID
                       name:(NSString *)name
                     gender:(NSString *)gender
                     avatar:(NSString *)avatar
                    success:(NetworkFetcherSuccessHandler)success
                    failure:(NetworkFetcherErrorHandler)failure;

@end
