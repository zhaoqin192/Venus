//
//  CouponCommentDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponCommentDetailViewModel : NSObject

@property (nonatomic, strong) RACSubject *commentSuccessObject;
@property (nonatomic, strong) RACSubject *commentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *commentString;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)sendCommentWithOrderID:(NSString *)orderID
                      couponID:(NSString *)couponID
                       storeID:(NSString *)storeID;



@end
