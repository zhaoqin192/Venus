//
//  NetworkFetcher+Mall.m
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher+Mall.h"

@implementation NetworkFetcher (Mall)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = NO;

+ (void)mallGetCategoryWithSuccess:(NetworkFetcherSuccessHandler)success
                           failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/bazaar/mallcategory/getCategory"]];
    
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

+ (void)mallGetKindArrayWithIdentifier:(NSString *)identifier
                                  page:(NSNumber *)page
                              capacity:(NSNumber *)capacity
                                  sort:(NSNumber *)sort
                               success:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/bazaar/mallIndex/search"]];
    
    NSDictionary *parameters = @{@"catId": identifier, @"page": page, @"pageSize": capacity, @"order": sort};
    
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

+ (void)mallSearchWithKeywords:(NSString *)keywords
                          page:(NSNumber *)page
                      capacity:(NSNumber *)capacity
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/bazaar/index/indexSearch4App"]];
    
    NSDictionary *parameters = @{@"name": keywords, @"page": page, @"pageSize": capacity};
    
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
