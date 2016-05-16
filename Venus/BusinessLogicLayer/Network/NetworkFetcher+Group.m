//
//  NetworkFetcher+Group.m
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher+Group.h"

@implementation NetworkFetcher (Group)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = YES;

+ (void)groupFetchMenuDataWithSuccess:(NetworkFetcherSuccessHandler)success
                              failure:(NetworkFetcherErrorHandler)failure {
    
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/couponz/customer/listCategory"]];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(nil);
    }];
    
}


+ (void)groupFetchCouponsWithType:(NSString *)type
                             sort:(NSString *)sort
                             page:(NSNumber *)page
                         capacity:(NSNumber *)capacity
                          success:(NetworkFetcherSuccessHandler)success
                          failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/couponz/customer/listAllCoupons"]];
    
    NSDictionary *parameters = nil;
    if (type == nil) {
        parameters = @{@"sortBy": sort, @"sequence": @"desc", @"page": page, @"capacity": capacity};
    }
    else {
        parameters = @{@"typeId": type, @"sortBy": sort, @"sequence": @"desc", @"page": page, @"capacity": capacity};
    }
    
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(nil);
    }];
    
    
    
}



@end
