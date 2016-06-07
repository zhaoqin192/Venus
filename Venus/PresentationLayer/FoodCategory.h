//
//  FoodCategory.h
//  Venus
//
//  Created by EdwinZhou on 16/6/6.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodCategory : NSObject

@property (assign, nonatomic) long id;
@property (assign, nonatomic) long store_id;
@property (assign, nonatomic) int rank;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;

@end
