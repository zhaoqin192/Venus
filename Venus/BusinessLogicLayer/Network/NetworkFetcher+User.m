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
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"

@implementation NetworkFetcher (User)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = YES;

+ (void)userLoginWithAccount:(NSString *)phone
                    password:(NSString *)password
                     success:(void (^)(NSDictionary *response))success
                     failure:(NetworkFetcherErrorHandler)failure{
    
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/loginsubmit"]];
    NSDictionary *parameters = @{@"account": phone, @"password": password};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        
        failure(@"网络异常");
    }];
    
}

+ (void)userQQLoginWithSuccess:(NetworkFetcherCompletionHandler)success
                       failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/qqlogin"]];
    NSDictionary *parameters = @{@"redirectUrl": @"www.chinaworldstyle.com/"};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (LOGDEBUG) {
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

+ (void)userFetchAccessTokenWithCode:(NSString *)code
                             success:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/oauth2/access_token"];
    NSDictionary *parameters = @{@"appid": @"wxbafcc387a8a8fe31", @"secret": @"e29832b3d0608a4d41c839e160be7bc6", @"code": code, @"grant_type": @"authorization_code"};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        [NetworkFetcher userWeChatIsBoundWithOpenID:responseObject[@"openid"] token:responseObject[@"access_token"] success:^{
            
        } failure:^(NSString *error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
    }];
    
}

+ (void)userFetchUserInfoWithWeChatToken:(NSString *)token
                                  openID:(NSString *)openID
                                 Success:(void (^)(NSDictionary *userInfo))success
                                 failure:(NetworkFetcherErrorHandler)faiure{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/userinfo"];
    NSDictionary *parameters = @{@"access_token": token, @"openid": openID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *userInfo = responseObject;
        success(userInfo);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
    }];
}

+ (void)userBindWeChatWithOpenID:(NSString *)openID
                            name:(NSString *)name
                             sex:(NSNumber *)sex
                          avatar:(NSString *)avatar
                         account:(NSString *)phone
                        password:(NSString *)password
                           token:(NSString *)token
                         unionID:(NSString *)unionID
                         success:(NetworkFetcherSuccessHandler)success
                         failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    
    NSString *urlString = [[[[[[[[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/weixin/bind/mobile?openId="] stringByAppendingString:openID] stringByAppendingString:@"&name="] stringByAppendingString:name] stringByAppendingString:@"&sex="] stringByAppendingString:[NSString stringWithFormat:@"%d", [sex intValue]]] stringByAppendingString:@"&headImgUrl="] stringByAppendingString:avatar];
    
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSDictionary *parameters = @{@"token": token, @"password": password};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        
        failure(@"网络异常");
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
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        if([responseObject[@"isBound"] isEqualToNumber:@1]){
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.token = responseObject[@"uid"];
            [accountDao save];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTER_HOME" object:nil];
        }else{
            //注册新的国贸用户
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATE_ACCOUNT" object:nil userInfo:@{@"openID": openID, @"token": token}];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
    }];
    
}

+ (void)userCheckMobileWithNumber:(NSString *)number
                          success:(NetworkFetcherCompletionHandler)success
                          failure:(NetworkFetcherErrorHandler)failure{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/check/mobile"]];
    NSDictionary *parameters = @{@"mobile": number};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        if(!responseObject[@"is_exists"]){
            
        }else{
            failure(@"exists");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
    }];
}

+ (void)userRegisterWithPhone:(NSString *)phone
                     password:(NSString *)password
                        token:(NSString *)token
                      success:(NetworkFetcherSuccessHandler)success
                      failure:(NetworkFetcherErrorHandler)failure{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/customer/register/mobile"]];
    NSDictionary *parameters = @{@"name": phone, @"password": password, @"token": token};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
        
        //        NSDictionary *response = responseObject;
        //        if([response[@"errCode"] isEqualToNumber:@0]){
        //            success();
        //        }else{
        //            failure(response[@"msg"]);
        //        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        
        failure(@"网络异常");
    }];
}

+ (void)userSendCodeWithNumber:(NSString *)number
                       success:(NetworkFetcherSuccessHandler)success
                       failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/sms/sendcode"]];
    NSDictionary *parameters = @{@"mobile": number};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
        
        //        if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
        //            success();
        //        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
}


+ (void)userValidateSMS:(NSString *)code
                 mobile:(NSString *)number
                success:(void (^)(NSDictionary *response))success
                failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/sms/validate"]];
    NSDictionary *parameters = @{@"mobile": number, @"code": code};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        //        if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
        //            success(responseObject[@"token"]);
        //        }else{
        //            failure(@"验证码不正确");
        //        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
    
}

+ (void)userFetchUserInfoWithQQToken:(NSString *)token
                              openID:(NSString *)openID
                             success:(void (^)(NSDictionary *userInfo))success
                             failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:@"https://openmobile.qq.com/user/get_simple_userinfo"];
    NSDictionary *parameters = @{@"access_token": token, @"oauth_consumer_key": @"1105340672", @"openid": openID};
    
    NSLog(@"token---%@", token);
    NSLog(@"openID--%@", openID);
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *userInfo = responseObject;
        success(userInfo);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
    
    
}

+ (void)userQQIsBoundWithOpenID:(NSString *)openID
                          token:(NSString *)token
                        success:(NetworkFetcherCompletionHandler)success
                        failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/isbound/qq"]];
    NSDictionary *parameters = @{@"openId": openID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        if([responseObject[@"isBound"] isEqualToNumber:@1]){
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.token = responseObject[@"userid"];
            [accountDao save];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTER_HOME" object:nil];
        }else{
            //注册新的国贸用户
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATE_ACCOUNT" object:nil userInfo:@{@"openID": openID, @"token": token}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
    
}

+ (void)userBindQQWithOpenID:(NSString *)openID
                        name:(NSString *)name
                      avatar:(NSString *)avatar
                     account:(NSString *)phone
                    password:(NSString *)password
                       token:(NSString *)token
                     success:(NetworkFetcherSuccessHandler)success
                     failure:(NetworkFetcherErrorHandler)failure{
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    
    NSString *urlString = [[[[[[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/qq/bind/mobile?openId="] stringByAppendingString:openID] stringByAppendingString:@"&name="] stringByAppendingString:name] stringByAppendingString:@"&figure="] stringByAppendingString:avatar];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSDictionary *parameters = @{@"token": token, @"password": password};
    
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        
        success(responseObject);
        
        //        if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
        //            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
        //            Account *account = [accountDao fetchAccount];
        //            account.openID = openID;
        //            account.nickName = name;
        //            account.avatar = avatar;
        //            account.phone = phone;
        //            account.password = password;
        //            account.token = responseObject[@"userid"];
        //            [accountDao save];
        //        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        
        failure(@"网络异常");
    }];
    
    
}


@end





















