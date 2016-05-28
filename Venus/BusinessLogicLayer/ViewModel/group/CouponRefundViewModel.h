//
//  CouponRefundViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponRefundViewModel : NSObject

@property (nonatomic, strong) RACSubject *refundSuccessObject;
@property (nonatomic, strong) RACSubject *refundFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *refundArray;


- (void)fetchRefundData;

- (void)cacheData;

- (void)refreshData;

@end
