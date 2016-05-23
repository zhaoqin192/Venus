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

@implementation HomeViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.loginSuccessObject = [RACSubject subject];
        self.loginFailureObject = [RACSubject subject];
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
            
        } failure:^(NSString *error) {
            
        }];
        
    }
    
}


@end
