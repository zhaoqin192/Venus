//
//  HomeViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "HomeViewModel.h"
#import "NetworkFetcher+User.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "NetworkFetcher+Home.h"
#import "HeadlineModel.h"

@implementation HomeViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.loginSuccessObject = [RACSubject subject];
        self.loginFailureObject = [RACSubject subject];
        self.headlineSuccessObject = [RACSubject subject];
        self.headlineFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}


- (void)login {
    
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if (account.phone == nil || account.password == nil) {
        [self.loginFailureObject sendNext:nil];
    }
    else {
        [NetworkFetcher userLoginWithAccount:account.phone password:account.password success:^(NSDictionary *response) {
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                Account *account = [accountDao fetchAccount];
                account.token = response[@"userid"];
                [accountDao save];
                accountDao.isLogin = YES;
            }
        } failure:^(NSString *error) {
            [_errorObject sendNext:@"网络异常"];
        }];
        
    }
    
}

- (void)fetchHeadline {
    
    [NetworkFetcher homeFetcherHeadlineArrayWithSuccess:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [HeadlineModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"abstract": @"summary"
                         };
            }];
            self.headlineArray = [HeadlineModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            [self.headlineSuccessObject sendNext:nil];
        }
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

@end
