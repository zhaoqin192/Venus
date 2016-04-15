//
//  NetworkManager.h
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface NetworkManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (NetworkManager *)sharedInstance;

- (AFHTTPSessionManager *)fetchSessionManager;

@end
