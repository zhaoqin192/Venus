//
//  MeShopCommit.h
//  Venus
//
//  Created by 王霄 on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeShopCommit : NSObject
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *content;
@end
