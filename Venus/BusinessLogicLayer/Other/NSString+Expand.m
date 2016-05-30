//
//  NSString+Expand.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NSString+Expand.h"

@implementation NSString (Expand)

+ (NSString *)convertTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue] / 1000];
    return [date stringWithFormat:@"yyyy-MM-dd"];
}

+ (NSString *)convertTimeUntilSecond:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue] / 1000];
    return [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (NSString*)urlEncodedString:(NSString *)string {
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

@end
