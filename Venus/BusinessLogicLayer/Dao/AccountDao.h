//
//  AccountDao.h
//  Venus
//
//  Created by zhaoqin on 4/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface AccountDao : NSObject

/**
 *  获取用户类
 *
 *  @return 
 */
- (Account *)fetchAccount;

/**
 *  判断是否有用户账号
 *
 *  @return
 */
- (BOOL)isLogin;

/**
 *  删除本机用户账号
 */
- (void)deleteAccount;

///**
// *  登录之后更新账号和密码
// *
// *  @param phone
// *  @param password
// *  @param token
// */
//- (void)insertAccountWithPhone:(NSString *)phone
//                      password:(NSString *)password
//                         token:(NSString *)token;

///**
// *  插入用户信息
// *
// *  @param nickName
// *  @param sex
// *  @param avatar
// *  @param openID
// */
//- (void)insertAccountWithNickName:(NSString *)nickName
//                              sex:(NSNumber *)sex
//                           avatar:(NSString *)avatar
//                           openID:(NSString *)openID;

/**
 *  保存
 */
- (void)save;

/**
 *  第三方登录刷新Token
 */
//- (void)refreshToken:(NSString *)token;

@end
 