//
//  Picture.h
//  Venus
//
//  Created by zhaoqin on 4/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;

@end
