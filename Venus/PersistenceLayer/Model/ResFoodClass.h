//
//  ResFoodClass.h
//  Venus
//
//  Created by zhaoqin on 5/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResFoodClass : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *foodArray;

@end
