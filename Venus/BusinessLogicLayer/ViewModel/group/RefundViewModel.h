//
//  RefundViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *selectReason;
@property (nonatomic, strong) NSMutableArray *selectCode;
@property (nonatomic, strong) NSArray *reasonArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger reasonCount;
@property (nonatomic, strong) RACSubject *refundSuccessObject;
@property (nonatomic, strong) RACSubject *refundFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)isValid;

- (void)commitRefundWithOrderID:(NSString *)orderID
                       couponID:(NSString *)couponID
                      codeArray:(NSArray *)codeArray;

@end
