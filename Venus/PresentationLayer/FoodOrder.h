//
//  FoodOrder.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PaymentStatus) {
    CashOnDelivery = 0,
    AliPay
};

@interface FoodOrder : NSObject

@property (copy, nonatomic) NSString *storeID;
@property (copy, nonatomic) NSString *recipient;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *remark;
@property (assign, nonatomic) PaymentStatus payStatus;
@property (assign, nonatomic) long arriveTime;
@property (strong, nonatomic) 

@end
