//
//  MeMiamiCommit.h
//  Venus
//
//  Created by 王霄 on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeMiamiCommit : NSObject
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger orderCreateTime;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storePic;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *des;
@end
