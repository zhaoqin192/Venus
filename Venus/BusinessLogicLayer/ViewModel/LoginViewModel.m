//
//  LoginViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/7/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "LoginViewModel.h"
#import "NetworkFetcher+User.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "AppDelegate.h"
#import "SDKManager.h"
#import "GMRegisterViewController.h"

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";

@interface LoginViewModel ()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation LoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userNameSignal = RACObserve(self, userName);
        _passwordSignal = RACObserve(self, password);
        _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/loginsubmit"]];
                NSDictionary *parameters = @{@"account": _userName, @"password": _password};
                @weakify(manager)
                [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                        NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
                        for (NSString *key in cookieHeaders) {
                            @strongify(manager)
                            [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
                        }   
                    }
                    [subscriber sendNext:responseObject[@"errCode"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
    }
    return self;
}

- (id)buttonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal]
                          reduce:^id(NSString *userName, NSString *password) {
                              return @(userName.length == 11 && password.length >= 3);
                          }];
    return isValid;
}

//- (RACSignal *)login {
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
//        NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/loginsubmit"]];
//        NSDictionary *parameters = @{@"account": _userName, @"password": _password};
//        @weakify(manager)
//        [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
//                NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
//                NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
//                for (NSString *key in cookieHeaders) {
//                    @strongify(manager)
//                    [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
//                }
//            }
//            [subscriber sendNext:responseObject[@"errCode"]];
//            [subscriber sendCompleted];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [subscriber sendError:nil];
//        }];
//        return nil;
//    }];
//}

- (void)loginWithWeChat {
    self.appDelegate.state = WECHAT;
    [[SDKManager sharedInstance] sendAuthRequestWithWeChat];
}

- (void)loginWithQQ {
    self.appDelegate.state = QQ;
    [[SDKManager sharedInstance] sendAuthRequestWithQQ];
}


@end
