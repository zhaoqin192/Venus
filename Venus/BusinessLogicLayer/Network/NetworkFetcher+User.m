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

//+ (void)userLoginWithWeiXinSuccess:(NetworkFetcherCompletionHandler)success
//                            failure:(NetworkFetcherErrorHandler)failure{
//    
//    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
//    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/weixinlogin/login"]];
//    NSDictionary *parameters = @{@"redirectUrl": @"http://buscome.neoap.com/"};
//    
//    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}

+ (void)userFetchAccessTokenWithCode:(NSString *)code
                             success:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/oauth2/access_token"];
    NSDictionary *parameters = @{@"appid": @"wxbafcc387a8a8fe31", @"secret": @"e29832b3d0608a4d41c839e160be7bc6", @"code": code, @"grant_type": @"authorization_code"};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        [NetworkFetcher userWeChatIsBoundWithOpenID:responseObject[@"openid"] token:responseObject[@"access_token"] success:^{
            
        } failure:^(NSString *error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

+ (void)userFetchUserInfoWithToken:(NSString *)token
                            openID:(NSString *)openID
                           Success:(NetworkFetcherCompletionHandler)success
                           failure:(NetworkFetcherErrorHandler)faiure{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/userinfo"];
    NSDictionary *parameters = @{@"access_token": token, @"openid": openID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
//        [NetworkFetcher userBindWeChatWithOpenID:openID name:responseObject[@"nickname"] sex:responseObject[@"sex"] avatar:responseObject[@"headimgurl"] account:<#(NSString *)#> password:<#(NSString *)#> success:<#^(void)success#> failure:<#^(NSString *error)failure#>]
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)userBindWeChatWithOpenID:(NSString *)openID
                            name:(NSString *)name
                             sex:(NSNumber *)sex
                          avatar:(NSString *)avatar
                         account:(NSString *)account
                        password:(NSString *)password
                         success:(NetworkFetcherCompletionHandler)success
                         failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/weiixn/bind"]];
    NSDictionary *parameters = @{@"openid": openID, @"name": name, @"sex": sex, @"headImgUrl": avatar};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (true) {
            NSLog(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (true) {
            NSLog(@"%@", error);
        }
        
        failure(@"Network Error");
    }];
    
}

+ (void)userWeChatIsBoundWithOpenID:(NSString *)openID
                              token:(NSString *)token
                            success:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/isbound/weixin"]];
    NSDictionary *parameters = @{@"openId": openID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if(!responseObject[@"isBound"]){
            //获取用户信息进入主页面
            [NetworkFetcher userFetchUserInfoWithToken:token openID:openID Success:^{
                
            } failure:^(NSString *error) {
                
            }];
        }else{
            //注册新的国贸用户
            NSLog(@"new User");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


@end
