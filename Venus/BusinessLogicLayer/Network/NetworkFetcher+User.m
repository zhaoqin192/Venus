//
//  NetworkFetcher+User.m
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher+User.h"
#import "AFNetworking.h"
#import "NetworkManager.h"

@implementation NetworkFetcher (User)

static const NSString *URL_OF_USER_PREFIX = @"http://10.1.29.250:30222";

+ (void)userLoginWithAccount:(NSString *)account
                     password:(NSString *)password
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure{

    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/loginsubmit"]];
    NSDictionary *parameters = @{@"account": account, @"password": password};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (true) {
            NSLog(@"%@", responseObject);
        }
        
        NSDictionary *response = responseObject;
        
        if(response[@"errCode"] == 0){
            success();
        }else{
            failure(response[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (true) {
            NSLog(@"%@", error);
        }
        
        failure(@"Network Error");
    }];
    
}

+ (void)userQQLoginWithSuccess:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/qqlogin"]];
    NSDictionary *parameters = @{@"redirectUrl": @"http://buscome.neoap.com/"};

    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (true) {
            NSLog(@"%@", responseObject);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (true) {
            NSLog(@"%@", error);
        }
        
    }];

}

+ (void)userQQLoginCallBackWith:(NSString *)code
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/qqlogin/redirect"]];
    NSDictionary *parameters = @{@"code": code};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

+ (void)userLoginWithWeiXinSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/weixinlogin/login"]];
    NSDictionary *parameters = @{@"redirectUrl": @"http://buscome.neoap.com/"};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end
