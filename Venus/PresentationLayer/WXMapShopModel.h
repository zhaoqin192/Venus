//
//  WXMapShopModel.h
//  Venus
//
//  Created by 王霄 on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXMapShopModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *desp;
@property (nonatomic, assign) NSInteger identify;
@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, assign) NSInteger type;
@end
