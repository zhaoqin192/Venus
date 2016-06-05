//
//  BrandDetailCommentModel.h
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandDetailCommentModel : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *content;

@end
