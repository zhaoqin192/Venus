//
//  DatabaseManager.m
//  Venus
//
//  Created by zhaoqin on 4/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "DatabaseManager.h"
#import "AccountDao.h"

@implementation DatabaseManager

- (instancetype)init{
    self = [super init];
    self.accountDao = [[AccountDao alloc] init];
    return self;
}

+ (DatabaseManager *)sharedInstance{
    static DatabaseManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    return sharedInstance;
}

@end