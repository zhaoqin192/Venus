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

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACCommand *loginCommand;

- (id)buttonIsValid;

- (void)loginWithWeChat;

- (void)loginWithQQ;

@end
