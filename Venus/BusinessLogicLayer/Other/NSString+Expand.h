//
//  NSString+Expand.h
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expand)

+ (NSString *)convertTime:(NSNumber *)time;
+ (NSString *)convertTimeUntilSecond:(NSNumber *)time;

+ (NSString*)urlEncodedString:(NSString *)string;

@end
