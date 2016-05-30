//
//  TakeAwayOrderDetail.h
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeAwayOrderStore.h"
#import "TakeAwayOrderComment.h"
#import "TakeAwayOrderRefund.h"

@interface TakeAwayOrderDetail : NSObject

@property (assign, nonatomic) NSInteger orderID;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger refundState;
@property (assign, nonatomic) NSInteger packFee;
@property (assign, nonatomic) NSInteger totalFee;

@property (assign, nonatomic) NSInteger createTime;
@property (assign, nonatomic) NSInteger arriveTime;

@property (copy, nonatomic) NSString *remark;

@property (strong, nonatomic) TakeAwayOrderStore *store;
@property (strong, nonatomic) NSMutableArray *goodsDetail;
@property (strong, nonatomic) TakeAwayOrderComment *comment;
@property (strong, nonatomic) TakeAwayOrderRefund *refund;


@end
