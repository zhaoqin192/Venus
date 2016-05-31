//
//  FoodManager.h
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodManager : NSObject

@property (nonatomic, strong) NSMutableArray *foodClassArray;
@property (nonatomic, strong) NSMutableArray *resFoodClassArray;
@property (nonatomic, strong) NSMutableArray *foodArray;

+ (FoodManager *)sharedInstance;

@end
