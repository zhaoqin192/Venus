//
//  SignUpViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SignUpViewModel.h"
#import "NetworkFetcher+User.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"


@interface SignUpViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *authSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *rePasswordSignal;
@property (nonatomic, strong) NSString *token;

@end

@implementation SignUpViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _phoneSignal = RACObserve(self, phone);
        _authSignal = RACObserve(self, authCode);
        _passwordSignal = RACObserve(self, password);
        _rePasswordSignal = RACObserve(self, rePassword);
        _authSuccessSubject = [RACSubject subject];
        _authFailureSubject = [RACSubject subject];
        _signUpSuccessSubject = [RACSubject subject];
        _signUpFailureSubject = [RACSubject subject];
        _errorSubject = [RACSubject subject];
        _smsSuccessSubject = [RACSubject subject];
    }
    return self;
}

//- (id)authIsValid {
//    RACSignal *isValid = [[RACSignal combineLatest:@[_phoneSignal]
//                          reduce:^id(NSString *phone){
//                              return @(phone.length > 0);
//                          }]
//                          distinctUntilChanged];
//    return isValid;
//}
//
//- (id)authAlpha {
//    RACSignal *isValid = [[RACSignal combineLatest:@[_phoneSignal]
//                          reduce:^id(NSString *phone){
//                              return (phone.length > 0) ? @1.0f:@0.5f;
//                          }]
//                          distinctUntilChanged];
//    return isValid;
//}

- (id)signUpIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[_phoneSignal, _authSignal, _passwordSignal, _rePasswordSignal]
                                           reduce:^id(NSString *phone, NSString *authCode, NSString *password, NSString *rePassword){
                                               return @(phone.length == 11 && authCode.length >= 6 && password.length > 0 && rePassword.length > 0);
                                           }];
    return isValid;
}

- (void)auth {
    
    [NetworkFetcher userSendCodeWithNumber:_phone success:^(NSDictionary *response) {
        
        NSLog(@"%@", response);
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [_authSuccessSubject sendNext:nil];
        } else {
            [_authFailureSubject sendNext:@"输入的手机号无效"];
        }
        
    } failure:^(NSString *error) {
        [_errorSubject sendNext:@"网路异常"];
    }];
    
}

- (void)signUp {
    
}

- (void)smsAuth {
    
    [NetworkFetcher userValidateSMS:_authCode mobile:_phone success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            _token = response[@"token"];
            [_smsSuccessSubject sendNext:nil];
        } else {
            [_signUpFailureSubject sendNext:@"验证码不正确"];
        }
        
    } failure:^(NSString *error) {
        [_errorSubject sendNext:@"网路异常"];
    }];
    
}

- (void)originalSignUp {
    
    [NetworkFetcher userRegisterWithPhone:_phone password:_password token:_token success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [_signUpSuccessSubject sendNext:@"注册成功"];
        } else {
            [_signUpFailureSubject sendNext:@"注册失败"];
        }
        
    } failure:^(NSString *error) {
        
        [_errorSubject sendNext:@"网路异常"];
        
    }];
    
}

- (void)wechatSignUpWithToken:(NSString *)token openID:(NSString *)openID {
    
    [NetworkFetcher userFetchUserInfoWithWeChatToken:token openID:openID Success:^(NSDictionary *userInfo) {
        
        [NetworkFetcher userBindWeChatWithOpenID:userInfo[@"openid"] name:userInfo[@"nickname"] sex:userInfo[@"sex"] avatar:userInfo[@"headimgurl"] account:_phone password:_password token:_token unionID:userInfo[@"unionid"] success:^(NSDictionary *response) {
            
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                Account *account = [accountDao fetchAccount];
                account.openID = userInfo[@"openid"];
                account.unionID = userInfo[@"unionid"];
                account.token = response[@"userid"];
                account.nickName = userInfo[@"nickname"];
                account.sex = userInfo[@"sex"];
                account.avatar = userInfo[@"headimgurl"];
                account.phone = _phone;
                account.password = _password;
                [accountDao save];
                [_signUpSuccessSubject sendNext:@"绑定成功"];
            } else {
                [_signUpFailureSubject sendNext:@"绑定失败"];
            }
            
        } failure:^(NSString *error) {
            [_errorSubject sendNext:@"网路异常"];
        }];
        
    } failure:^(NSString *error) {
        [_errorSubject sendNext:@"网路异常"];
    }];
    
}

- (void)qqSignUpWithToken:(NSString *)token openID:(NSString *)openID {
    
    [NetworkFetcher userFetchUserInfoWithQQToken:token openID:openID success:^(NSDictionary *userInfo) {
        
        [NetworkFetcher userBindQQWithOpenID:openID name:userInfo[@"nickname"] avatar:userInfo[@"figureurl_qq_1"] account:_phone password:_password token:_token gender:userInfo[@"gender"] success:^(NSDictionary *response){
            
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                Account *account = [accountDao fetchAccount];
                account.openID = openID;
                account.nickName = userInfo[@"nickname"];
                account.avatar = userInfo[@"figureurl_qq_1"];
                account.password = _password;
                account.phone = _phone;
                if ([userInfo[@"gender"] isEqualToString:@"男"]) {
                    account.sex = @1;
                }
                else {
                    account.sex = @2;
                }
                account.token = response[@"userid"];
                [accountDao save];
                [_signUpSuccessSubject sendNext:@"绑定成功"];
            } else {
                [_signUpFailureSubject sendNext:@"绑定失败"];
            }
            
            
        } failure:^(NSString *error) {
            [_errorSubject sendNext:@"网路异常"];
        }];
        
    } failure:^(NSString *error) {
        [_errorSubject sendNext:@"网路异常"];
    }];
    
    
}


@end
