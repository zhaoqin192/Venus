//
//  FoodAddressManager.h
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodAddressManager : NSObject

@property (copy, nonatomic) NSMutableArray *foodAddressArray;
@property (copy, nonatomic) NSString *userID;

+ (FoodAddressManager *)sharedInstance;

@end
