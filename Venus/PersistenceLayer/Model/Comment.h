//
//  Comment.h
//  Venus
//
//  Created by zhaoqin on 5/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *costTime;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;

@end
