//
//  AppCacheManager.h
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCacheManager : NSObject

+ (NSMutableArray *)fetchCacheDataWithFileName:(NSString *)fileName;

+ (void)cacheDataWithData:(NSMutableArray *)data
                 fileName:(NSString *)fileName;

+ (void)cacheCookie:(NSString *)cookie;

+ (NSString *)fetchCookie;

+ (void)deleteCookie;

@end
