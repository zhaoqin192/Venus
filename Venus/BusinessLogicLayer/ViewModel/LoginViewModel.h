//
//  LoginViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/7/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)buttonIsValid;

- (void)login;

- (void)loginWithWeChat;

- (void)loginWithQQ;

@end
