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
//#import "ReactiveCocoa.h"


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
        _successObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];
        _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
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


- (void)login {
    
    [NetworkFetcher userLoginWithAccount:_userName password:_password success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.phone = _userName;
            account.password = _password;
            account.token = response[@"userid"];
            [accountDao save];
            [_successObject sendNext:nil];
        } else {
            [_failureObject sendNext:@"用户名或密码错误"];
        }
    } failure:^(NSString *error) {
        [_errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)loginWithWeChat {
    self.appDelegate.state = WECHAT;
    [[SDKManager sharedInstance] sendAuthRequestWithWeChat];
}

- (void)loginWithQQ {
    self.appDelegate.state = QQ;
    [[SDKManager sharedInstance] sendAuthRequestWithQQ];
}


@end
