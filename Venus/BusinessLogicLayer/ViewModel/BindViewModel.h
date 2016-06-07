//
//  BindViewModel.h
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindViewModel : NSObject

@property (nonatomic, strong) RACSubject *bindSuccessObject;
@property (nonatomic, strong) RACSubject *bindFailureObject;
@property (nonatomic, strong) RACSubject *infoSuccessObject;
@property (nonatomic, strong) RACSubject *infoFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSString *unionID;
@property (nonatomic, strong) NSString *openID;

- (void)bindWechat;

- (void)bindQQ;

- (void)fetcheWechatInfoWithToken:(NSString *)token
                           openID:(NSString *)openID;

- (void)fetchQQInfoWithToken:(NSString *)token
                      openID:(NSString *)openID;

- (id)buttonIsValid;

@end
