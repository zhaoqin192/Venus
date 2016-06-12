//
//  SignUpViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/8/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpViewModel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rePassword;
@property (nonatomic, strong) RACSubject *authSuccessSubject;
@property (nonatomic, strong) RACSubject *signUpSuccessSubject;
@property (nonatomic, strong) RACSubject *smsSuccessSubject;
@property (nonatomic, strong) RACSubject *authFailureSubject;
@property (nonatomic, strong) RACSubject *signUpFailureSubject;
@property (nonatomic, strong) RACSubject *errorSubject;


//- (id)authIsValid;

//- (id)authAlpha;

- (id)signUpIsValid;

- (void)auth;

- (void)signUp;

- (void)smsAuth;

- (void)originalSignUp;

- (void)wechatSignUpWithToken:(NSString *)token openID:(NSString *)openID;

- (void)qqSignUpWithToken:(NSString *)token openID:(NSString *)openID;


@end
