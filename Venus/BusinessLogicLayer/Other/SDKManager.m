//
//  SDKManager.m
//  Venus
//
//  Created by zhaoqin on 4/18/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SDKManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@interface SDKManager()<TencentSessionDelegate>

@end

@implementation SDKManager

static NSString *tencentAppID = @"1105340672";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:tencentAppID andDelegate:self];
    }
    return self;
}

+ (SDKManager *)sharedInstance{
    static SDKManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SDKManager alloc] init];
    });
    return sharedInstance;
}

- (void)authorWithQQ{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
//                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                            kOPEN_PERMISSION_ADD_ALBUM,
//                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                            kOPEN_PERMISSION_ADD_SHARE,
//                            kOPEN_PERMISSION_ADD_TOPIC,
//                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                            kOPEN_PERMISSION_GET_INFO,
//                            kOPEN_PERMISSION_GET_OTHER_INFO,
//                            kOPEN_PERMISSION_LIST_ALBUM,
//                            kOPEN_PERMISSION_UPLOAD_PIC,
//                            kOPEN_PERMISSION_GET_VIP_INFO,
//                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [self.tencentOAuth authorize:permissions inSafari:YES];
}

- (void)tencentDidLogin{
    NSLog(@"didLogin");
    NSLog(@"%@", [self.tencentOAuth accessToken]);
    NSLog(@"%@", [self.tencentOAuth openId]);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessed" object:self];
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"didNotLogin");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCancelled" object:self];
}

- (void)tencentDidNotNetWork{
    NSLog(@"didNotNetwork");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginFailed" object:self];
}

@end
