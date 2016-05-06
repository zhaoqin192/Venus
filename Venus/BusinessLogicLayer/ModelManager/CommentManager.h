//
//  CommentManager.h
//  Venus
//
//  Created by zhaoqin on 5/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentManager : NSObject

@property (nonatomic, strong) NSMutableArray *commentArray;

+ (CommentManager *)sharedManager;

@end
