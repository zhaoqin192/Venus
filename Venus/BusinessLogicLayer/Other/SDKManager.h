//
//  SDKManager.h
//  Venus
//
//  Created by zhaoqin on 4/18/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TencentOAuth;

@interface SDKManager : NSObject


@property (nonatomic, strong) TencentOAuth *tencentOAuth;

+ (SDKManager *)sharedInstance;

- (void)authorWithQQ;

@end
