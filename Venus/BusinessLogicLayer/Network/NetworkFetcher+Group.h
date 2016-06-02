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
 *  @param capacity
 *  @param success
 *  @param failure
 */
+ (void)groupFetchCouponsWithType:(NSString *)type
                             sort:(NSString *)sort
                             page:(NSNumber *)page
                         capacity:(NSNumber *)capacity
                          success:(NetworkFetcherSuccessHandler)success
                          failure:(NetworkFetcherErrorHandler)failure;

/**
 *  团购劵详情接口
 *
 *  @param couponID
 *  @param success
 *  @param failure
 */
+ (void)groupFetchCouponDetailWithCouponID:(NSString *)couponID
                                   success:(NetworkFetcherSuccessHandler)success
                                   failure:(NetworkFetcherErrorHandler)failure;

/**
 *  团购劵获取评论接口
 *
 *  @param couponID
 *  @param page
 *  @param capacity
 *  @param success
 *  @param failure
 */
+ (void)groupFetchCommentsWithCouponID:(NSString *)couponID
                                  page:(NSNumber *)page
                              capacity:(NSNumber *)capacity
                               success:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure;

/**
 *  客户下单生成orderID
 *
 *  @param couponID
 *  @param storeID
 *  @param num
 *  @param success
 *  @param failure
 */
+ (void)groupCreateOrderWithCouponID:(NSString *)couponID
                             storeID:(NSString *)storeID
                                 num:(NSNumber *)num
                             success:(NetworkFetcherSuccessHandler)success
                             failure:(NetworkFetcherErrorHandler)failure;

/**
 *  客户支付预下单
 *
 *  @param orderID
 *  @param method
 *  @param success
 *  @param failure
 */
+ (void)grougPrePayWithOrderID:(NSString *)orderID
                        method:(NSString *)method
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

/**
 *  客户获取个人订单
 *
 *  @param status
 *  @param success
 *  @param failure
 */
+ (void)groupFetchAccountOrderArrayWithStatus:(NSNumber *)status
                                      success:(NetworkFetcherSuccessHandler)success
                                      failure:(NetworkFetcherErrorHandler)failure;

/**
 *  团购劵订单详情
 *
 *  @param orderID
 *  @param success
 *  @param failure
 */
+ (void)groupFetchOrderDetailWithOrderID:(NSString *)orderID
                                 success:(NetworkFetcherSuccessHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure;

/**
 *  申请退款
 *
 *  @param orderID
 *  @param couponID
 *  @param codeArray
 *  @param reason
 *  @param success
 *  @param failure
 */
+ (void)groupRefundWithOrderID:(NSString *)orderID
                      couponID:(NSString *)couponID
                     codeArray:(NSArray *)codeArray
                        reason:(NSString *)reason
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure;

/**
 *  添加评论
 *
 *  @param orderID
 *  @param storeID
 *  @param couponID
 *  @param score
 *  @param content
 *  @param pictureURLArray
 *  @param success
 *  @param failure
 */
+ (void)groupSendCommentWithOrderID:(NSString *)orderID
                            storeID:(NSString *)storeID
                           couponID:(NSString *)couponID
                              score:(NSNumber *)score
                            content:(NSString *)content
                    pictureURLArray:(NSArray *)pictureURLArray
                            success:(NetworkFetcherSuccessHandler)success
                            failure:(NetworkFetcherErrorHandler)failure;

/**
 *  上传图片获取URL地址
 *
 *  @param imageArray
 *  @param success
 *  @param failure
 */
+ (void)groupUploadImageArray:(NSMutableArray *)imageArray
                      success:(NetworkFetcherSuccessHandler)success
                      failure:(NetworkFetcherErrorHandler)failure;

@end
