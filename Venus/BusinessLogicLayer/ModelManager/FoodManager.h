//
//  FoodManager.h
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodManager : NSObject

@property (nonatomic, copy) NSMutableArray *foodClassArray;
@property (nonatomic, copy) NSMutableArray *resFoodClassArray;
@property (nonatomic, copy) NSMutableArray *foodArray;

+ (FoodManager *)sharedInstance;

@end
