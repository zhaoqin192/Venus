//
//  CouponCommentModel.h
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponCommentModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSMutableArray *pictureArray;

@end
