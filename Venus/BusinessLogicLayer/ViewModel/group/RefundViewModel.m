//
//  RefundViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "RefundViewModel.h"
#import "NetworkFetcher+Group.h"

@interface RefundViewModel()

@property (nonatomic, strong) RACSignal *countSignal;
@property (nonatomic, strong) RACSignal *reasonSignal;

@end

@implementation RefundViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reasonArray = [NSArray arrayWithObjects:@"商家拒绝接待", @"商家倒闭/装修/搬迁", @"套餐内容/有效期与网页不符", @"朋友/网友评价不好", @"去过了/不太满意", @"计划有变/没时间消费", @"后悔了/不想要了", nil];
        self.selectReason = [[NSMutableArray alloc] init];
        self.selectCode = [[NSMutableArray alloc] init];
        
        self.countSignal = RACObserve(self, count);
        self.reasonSignal = RACObserve(self, reasonCount);
        self.count = 0;
        
        self.refundSuccessObject = [RACSubject subject];
        self.refundFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (id)isValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.countSignal, self.reasonSignal] reduce:^id(NSNumber *count, NSNumber *reasonCount){
        return @([count integerValue]  > 0 && [reasonCount integerValue] > 0);
    }];
    return isValid;
    
}

- (void)commitRefundWithOrderID:(NSString *)orderID
                       couponID:(NSString *)couponID
                      codeArray:(NSArray *)codeArray {
    
    [NetworkFetcher groupRefundWithOrderID:orderID couponID:couponID codeArray:codeArray reason:[self.selectReason description] success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [self.refundSuccessObject sendNext:nil];
        }
        else {
            [self.refundFailureObject sendNext:@"申请失败"];
        }
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

@end
