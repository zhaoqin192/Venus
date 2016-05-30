//
//  TakeAwayOrderGood.h
//  Venus
//
//  Created by EdwinZhou on 16/5/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeAwayOrderGood : NSObject

@property (assign, nonatomic) long orderGoodsId;
@property (assign, nonatomic) long orderId;
@property (assign, nonatomic) long goodsId;
@property (copy, nonatomic) NSString *goodsName;
@property (assign, nonatomic) CGFloat price;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) NSInteger num;

@end
