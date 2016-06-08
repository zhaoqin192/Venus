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

@interface BindViewModel ()

@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;

@end

@implementation BindViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bindSuccessObject = [RACSubject subject];
        self.bindFailureObject = [RACSubject subject];
        self.infoSuccessObject = [RACSubject subject];
        self.infoFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.phoneSignal = RACObserve(self, phone);
        self.passwordSignal = RACObserve(self, password);
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

- (void)bindWechat {
    
    @weakify(self)
    [NetworkFetcher userWechatBindWithPhone:self.phone password:self.password openID:self.openID name:self.accountName sex:self.sex avatar:self.avatar unionID:self.unionID success:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.openID = _openID;
            account.unionID = _unionID;
            account.token = response[@"userid"];
            account.nickName = _accountName;
            account.sex = _sex;
            account.avatar = _avatar;
            account.phone = _phone;
            account.password = _password;
            [accountDao save];
            
            [self.bindSuccessObject sendNext:nil];
        }
        else {
            [self.bindFailureObject sendNext:@"用户名或密码错误"];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];

    
}

- (void)bindQQ {
    @weakify(self)
    [NetworkFetcher userQQBindWithPhone:self.phone password:self.password openID:self.openID name:self.accountName gender:[self.sex stringValue] avatar:self.avatar success:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
            Account *account = [accountDao fetchAccount];
            account.openID = _openID;
            account.unionID = _unionID;
            account.token = response[@"uid"];
            account.nickName = _accountName;
            account.sex = _sex;
            account.avatar = _avatar;
            account.phone = _phone;
            account.password = _password;
            [accountDao save];
            
            [self.bindSuccessObject sendNext:nil];
        }
        else {
            [self.bindFailureObject sendNext:@"用户名或密码错误"];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
}

- (void)fetcheWechatInfoWithToken:(NSString *)token
                           openID:(NSString *)openID {
    
    @weakify(self)
    [NetworkFetcher userFetchUserInfoWithWeChatToken:token openID:openID Success:^(NSDictionary *userInfo) {
        @strongify(self)
        self.accountName = userInfo[@"nickname"];
        self.avatar = userInfo[@"headimgurl"];
        self.openID = userInfo[@"openid"];
        self.unionID = userInfo[@"unionid"];
        self.sex = userInfo[@"sex"];
        [self.infoSuccessObject sendNext:nil];
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)fetchQQInfoWithToken:(NSString *)token
                      openID:(NSString *)openID {
    @weakify(self)
    [NetworkFetcher userFetchUserInfoWithQQToken:token openID:openID success:^(NSDictionary *userInfo) {
        @strongify(self)
        self.accountName = userInfo[@"nickname"];
        self.avatar = userInfo[@"figureurl_qq_2"];
        self.openID = openID;
        if ([userInfo[@"gender"] isEqualToString:@"男"]) {
            self.sex = @0;
        }
        else {
            self.sex = @1;
        }
        [self.infoSuccessObject sendNext:nil];
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

@end
