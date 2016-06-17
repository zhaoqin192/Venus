//
//  BindViewModel.m
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BindViewModel.h"
#import "NetworkFetcher+User.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "Appdelegate.h"

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";

@interface BindViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation BindViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.phoneSignal = RACObserve(self, phone);
        self.passwordSignal = RACObserve(self, password);
        
        @weakify(self)
        self.wechatInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/userinfo"];
                NSDictionary *parameters = @{@"access_token": input[@"token"], @"openid": input[@"openID"]};
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *userInfo = responseObject;
                    @strongify(self)
                    self.accountName = userInfo[@"nickname"];
                    self.avatar = userInfo[@"headimgurl"];
                    self.openID = userInfo[@"openid"];
                    self.unionID = userInfo[@"unionid"];
                    self.sex = userInfo[@"sex"];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.qqInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:@"https://openmobile.qq.com/user/get_simple_userinfo"];
                NSDictionary *parameters = @{@"access_token": input[@"token"], @"oauth_consumer_key": @"1105340672", @"openid": input[@"openID"]};
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *userInfo = responseObject;
                    @strongify(self)
                    self.accountName = userInfo[@"nickname"];
                    self.avatar = userInfo[@"figureurl_qq_2"];
                    self.openID = input[@"openID"];
                    if ([userInfo[@"gender"] isEqualToString:@"男"]) {
                        self.sex = @0;
                    }
                    else {
                        self.sex = @1;
                    }
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            if (_appDelegate.state == QQ) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                    NSURL *url = [NSURL URLWithString:@"https://openmobile.qq.com/user/get_simple_userinfo"];
                    NSDictionary *parameters = @{@"access_token": input[@"token"], @"oauth_consumer_key": @"1105340672", @"openid": input[@"openID"]};
                    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *userInfo = responseObject;
                        @strongify(self)
                        self.accountName = userInfo[@"nickname"];
                        self.avatar = userInfo[@"figureurl_qq_2"];
                        self.openID = input[@"openID"];
                        if ([userInfo[@"gender"] isEqualToString:@"男"]) {
                            self.sex = @0;
                        }
                        else {
                            self.sex = @1;
                        }
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                    return nil;
                }];
            }
            else if (_appDelegate.state == WECHAT){
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/userinfo"];
                    NSDictionary *parameters = @{@"access_token": input[@"token"], @"openid": input[@"openID"]};
                    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *userInfo = responseObject;
                        @strongify(self)
                        self.accountName = userInfo[@"nickname"];
                        self.avatar = userInfo[@"headimgurl"];
                        self.openID = userInfo[@"openid"];
                        self.unionID = userInfo[@"unionid"];
                        self.sex = userInfo[@"sex"];
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [subscriber sendError:nil];
                    }];
                    return nil;
                }];
            }
            else {
                return nil;
            }
        }];
        
        
        self.bindCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               if (_appDelegate.state == QQ) {
                   AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                   NSString *urlString = [[[[[[[[URL_OF_USER_PREFIX
                                                 stringByAppendingString:@"/terra/api/qq/bind?openId="]
                                                stringByAppendingString:_openID]
                                               stringByAppendingString:@"&name="]
                                              stringByAppendingString:_accountName]
                                             stringByAppendingString:@"&gender="]
                                            stringByAppendingString:[_sex stringValue]]
                                           stringByAppendingString:@"&figure="]
                                          stringByAppendingString:_avatar];
                   urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                   NSURL *url = [NSURL URLWithString:urlString];
                   NSDictionary *parameters = @{@"account": _phone, @"password": _password};
                   @weakify(manager)
                   [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                       NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
                       for (NSString *key in cookieHeaders) {
                           @strongify(manager)
                           [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
                       }
                       if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                           AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                           Account *account = [accountDao fetchAccount];
                           account.openID = _openID;
                           account.unionID = _unionID;
                           account.token = responseObject[@"uid"];
                           account.nickName = _accountName;
                           account.sex = _sex;
                           account.avatar = _avatar;
                           account.phone = _phone;
                           account.password = _password;
                           [accountDao save];
                       }
                       [subscriber sendNext:responseObject[@"errCode"]];
                       [subscriber sendCompleted];
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       [subscriber sendError:nil];
                   }];
               }
               else if (_appDelegate.state == WECHAT) {
                   AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                   NSString *urlString = [[[[[[[[[[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/api/weixin/bind?openId="] stringByAppendingString:_openID] stringByAppendingString:@"&name="] stringByAppendingString:_accountName] stringByAppendingString:@"&sex="] stringByAppendingString:[NSString stringWithFormat:@"%d", [_sex intValue]]] stringByAppendingString:@"&headImgUrl="] stringByAppendingString:_avatar] stringByAppendingString:@"&unionid="] stringByAppendingString:_unionID];
                   urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                   NSURL *url = [NSURL URLWithString:urlString];
                   NSDictionary *parameters = @{@"account": _phone, @"password": _password};
                   
                   @weakify(manager)
                   [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                       NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
                       for (NSString *key in cookieHeaders) {
                           @strongify(manager)
                           [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
                       }
                       if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                           AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                           Account *account = [accountDao fetchAccount];
                           account.openID = _openID;
                           account.unionID = _unionID;
                           account.token = responseObject[@"userid"];
                           account.nickName = _accountName;
                           account.sex = _sex;
                           account.avatar = _avatar;
                           account.phone = _phone;
                           account.password = _password;
                           [accountDao save];
                       }
                       [subscriber sendNext:responseObject[@"errCode"]];
                       [subscriber sendCompleted];
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       [subscriber sendError:nil];
                   }];
               }
               return nil;
           }];
        }];
        
    }
    return self;
}

- (id)buttonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal, _passwordSignal]
                          reduce:^id(NSString *phone, NSString *password){
                              return @(phone.length == 11 && password.length > 0);
                          }];
    return isValid;
    
}

@end
