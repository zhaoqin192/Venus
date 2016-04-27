//
//  PictureManager.h
//  Venus
//
//  Created by zhaoqin on 4/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureManager : NSObject

@property (nonatomic, copy) NSMutableArray *loopPictureArray;
@property (nonatomic, copy) NSMutableArray *recommendPictureArray;

+ (PictureManager *)sharedInstance;

@end
