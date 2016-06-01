//
//  CouponDetailViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponDetailViewModel.h"
#import "NetworkFetcher+Group.h"
#import "CouponCommentModel.h"

@interface CouponDetailViewModel ()

@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, strong) NSArray *useRuleArray;
@property (nonatomic, strong) NSArray *tipsArray;
@end

@implementation CouponDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailSuccessObject = [RACSubject subject];
        self.detailFailureObject = [RACSubject subject];
        self.commentSuccessObject = [RACSubject subject];
        self.commentFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.currentPage = 1;
        self.totalPage = 1;
        self.capacity = 10;
    }
    return self;
}

- (void)fetchDetailWithCouponID:(NSString *)couponID {
    
    [NetworkFetcher groupFetchCouponDetailWithCouponID:couponID success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            NSDictionary *coupon = response[@"coupon"];
            self.useRuleArray = coupon[@"useRule"];
            self.tipsArray = coupon[@"warmTip"];
            
            [self.detailSuccessObject sendNext:nil];
        }
        
        
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
}

- (void)fetchCommentWithCouponID:(NSString *)couponID
                            page:(NSNumber *)page {
    
    @weakify(self)
    [NetworkFetcher groupFetchCommentsWithCouponID:couponID page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"commentId",
                            @"pictureArray": @"picUrl"
                         };
            }];
            
            NSDictionary *nums = response[@"nums"];
            NSInteger totalNums = [nums[@"totalNum"] integerValue];
            @strongify(self)
            if (totalNums % self.capacity == 0) {
                self.totalPage = totalNums / self.capacity;
            }
            else {
                self.totalPage = totalNums / self.capacity + 1;
            }
            self.currentPage = [page integerValue];
            self.commentArray = [CouponCommentModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            [self.commentSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];

}

- (void)loadMoreCommentWithCouponID:(NSString *)couponID
                               page:(NSNumber *)page {
    
    
    @weakify(self)
    [NetworkFetcher groupFetchCommentsWithCouponID:couponID page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"commentId",
                         @"pictureArray": @"picUrl"
                         };
            }];
            
            NSDictionary *nums = response[@"nums"];
            NSInteger totalNums = [nums[@"totalNum"] integerValue];
            @strongify(self)
            if (totalNums % self.capacity == 0) {
                self.totalPage = totalNums / self.capacity;
            }
            else {
                self.totalPage = totalNums / self.capacity + 1;
            }
            self.currentPage = [page integerValue];
            [self.commentArray addObjectsFromArray:[CouponCommentModel mj_objectArrayWithKeyValuesArray:response[@"result"]]];
            [self.commentSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

@end
