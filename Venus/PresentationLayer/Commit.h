//
//  Commit.h
//  Venus
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commit : NSObject
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger time;
@end
