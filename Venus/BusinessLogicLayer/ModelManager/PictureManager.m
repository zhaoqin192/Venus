//
//  PictureManager.m
//  Venus
//
//  Created by zhaoqin on 4/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "PictureManager.h"

@implementation PictureManager

- (instancetype)init {
    self = [super init];
    self.loopPictureArray = [[NSMutableArray alloc] init];
    self.recommendPictureArray = [[NSMutableArray alloc] init];
    return self;
}

+ (PictureManager *)sharedInstance {
    static PictureManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PictureManager alloc] init];
    });
    
    return sharedInstance;
}


@end
