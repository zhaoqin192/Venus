//
//  AdvertisementManager.h
//  Venus
//
//  Created by zhaoqin on 4/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisementManager : NSObject

@property (nonatomic, copy) NSMutableArray *advertisementArray;

+ (AdvertisementManager *)sharedInstance;

@end
