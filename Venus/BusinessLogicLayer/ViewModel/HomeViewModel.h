//
//  HomeViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

@property (nonatomic, strong) RACSubject *loginSuccessObject;
@property (nonatomic, strong) RACSubject *loginFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)login;

@end
