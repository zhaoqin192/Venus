//
//  TakeAwayOrderRefund.h
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeAwayOrderRefund : NSObject

@property (assign, nonatomic) long id;
@property (assign, nonatomic) int amount;
@property (copy, nonatomic) NSString *customerDesc;
@property (copy, nonatomic) NSString *storeDesc;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) long timestamp;

@end
