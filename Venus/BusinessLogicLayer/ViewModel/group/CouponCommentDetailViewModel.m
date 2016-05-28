//
//  CouponCommentDetailViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentDetailViewModel.h"
#import "NetworkFetcher+Group.h"

@implementation CouponCommentDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.commentSuccessObject = [RACSubject subject];
        self.commentFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.score = @3;
        
    }
    return self;
}

- (void)sendCommentWithOrderID:(NSString *)orderID
                      couponID:(NSString *)couponID
                       storeID:(NSString *)storeID {
    
    [NetworkFetcher groupSendCommentWithOrderID:orderID storeID:storeID couponID:couponID score:self.score content:self.commentString success:^(NSDictionary *response) {
       
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [self.commentSuccessObject sendNext:@"评价成功"];
            
        }
        else {
            
            [self.commentFailureObject sendNext:@"评价失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];
    
}

@end
