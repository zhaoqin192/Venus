//
//  BindViewModel.h
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindViewModel : NSObject

@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSString *unionID;
@property (nonatomic, strong) NSString *openID;
@property (nonatomic, strong) RACCommand *wechatInfoCommand;
@property (nonatomic, strong) RACCommand *qqInfoCommand;
@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) RACCommand *bindCommand;

- (id)buttonIsValid;



@end
