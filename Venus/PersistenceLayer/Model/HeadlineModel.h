//
//  HeadlineModel.h
//  Venus
//
//  Created by zhaoqin on 6/2/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadlineModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *pictureURL;

@end
