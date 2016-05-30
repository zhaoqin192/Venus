//
//  TakeAwayOrder.h
//  Venus
//
//  Created by EdwinZhou on 16/5/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeAwayOrderStore.h"

@interface TakeAwayOrder : NSObject

@property (assign, nonatomic) NSInteger orderId;

@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger refundState;
@property (copy, nonatomic) NSString *stateDesc;

@property (assign, nonatomic) long createTime;
@property (assign, nonatomic) NSInteger totalFee;
@property (assign, nonatomic) NSInteger packFee;

@property (strong, nonatomic) TakeAwayOrderStore *store;
@property (strong, nonatomic) NSArray *goodsDetail;

@end
