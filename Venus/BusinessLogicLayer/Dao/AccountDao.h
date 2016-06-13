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

@property (nonatomic, assign) BOOL isLogin;

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

/**
 *  保存
 */
- (void)save;

@end
 