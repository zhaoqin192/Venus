//
//  DatabaseManager.h
//  Venus
//
//  Created by zhaoqin on 4/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountDao;

@interface DatabaseManager : NSObject
@property (nonatomic, strong) AccountDao* accountDao;

+ (DatabaseManager *)sharedInstance;

@end
