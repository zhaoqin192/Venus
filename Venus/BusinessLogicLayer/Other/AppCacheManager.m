//
//  AppCacheManager.m
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "AppCacheManager.h"

@implementation AppCacheManager

+ (NSMutableArray *)fetchCacheDataWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", fileName]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
}

+ (void)cacheDataWithData:(NSMutableArray *)data
                 fileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", fileName]];
    
    [NSKeyedArchiver archiveRootObject:data toFile:archivePath];
    
}

@end
