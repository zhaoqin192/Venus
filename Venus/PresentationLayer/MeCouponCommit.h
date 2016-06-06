//
//  MeCouponCommit.h
//  Venus
//
//  Created by 王霄 on 16/5/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeCouponCommit : NSObject
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSArray *picUrls;
@property (nonatomic, assign) BOOL haveImages;
@end
