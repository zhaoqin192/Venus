//
//  CommentManager.m
//  Venus
//
//  Created by zhaoqin on 5/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CommentManager.h"

@implementation CommentManager

- (instancetype)init {
    self = [super init];
    self.commentArray = [[NSMutableArray alloc] init];
    return self;
}

+ (CommentManager *)sharedManager {
    static CommentManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CommentManager alloc] init];
    });
    return sharedManager;
}

@end
