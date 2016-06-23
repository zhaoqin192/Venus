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
#import "CouponModel.h"

@interface CouponDetailViewModel ()

@property (nonatomic, assign) NSInteger capacity;
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
        self.useRule = [[NSString alloc] init];
        self.tips = [[NSString alloc] init];
        self.totalComment = @0;
    }
    return self;
}

- (void)fetchDetailWithCouponID:(NSString *)couponID {
    
    [NetworkFetcher groupFetchCouponDetailWithCouponID:couponID success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            NSDictionary *coupon = response[@"coupon"];
            
            self.couponModel = [CouponModel mj_objectWithKeyValues:coupon];
            self.couponModel.pictureUrl = coupon[@"picUrl"];
            
            NSArray *useRuleArray = coupon[@"useRule"];
            NSArray *tipsArray = coupon[@"warmTip"];
            if ([coupon[@"backable"] isEqualToNumber:@0]) {
                self.backable = NO;
            }
            else {
                self.backable = YES;
            }
            if ([coupon[@"mustOrder"] isEqualToNumber:@0]) {
                self.mustOrder = NO;
            }
            else {
                self.mustOrder = YES;
            }
            
            self.type = coupon[@"type"];
            self.moreDetailurl = coupon[@"richTextUrl"];
            
            for (NSString *string in useRuleArray) {
                if ([string isEqualToString:@""]) {
                    continue;
                }
                [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                self.useRule = [self.useRule stringByAppendingString:string];
                self.useRule = [self.useRule stringByAppendingString:@"\n"];
            }
            if (self.useRule.length > 0) {
                self.useRule = [self.useRule substringToIndex:self.useRule.length - 1];
            }
            for (NSString *string in tipsArray) {
                if ([string isEqualToString:@""]) {
                    continue;
                }
                [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                self.tips = [self.tips stringByAppendingString:string];
                self.tips = [self.tips stringByAppendingString:@"\n"];
            }
            if (self.tips.length > 0) {
                self.tips = [self.tips substringToIndex:self.tips.length - 1];
            }
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
                            @"pictureArray": @"picUrl",
                            @"avatarURL": @"userHeadImg"
                         };
            }];
            
            NSDictionary *nums = response[@"nums"];
            NSInteger totalNums = [nums[@"totalNum"] integerValue];
            self.totalComment = nums[@"totalNum"];
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
