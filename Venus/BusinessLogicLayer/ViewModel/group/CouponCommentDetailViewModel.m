//
//  CouponCommentDetailViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentDetailViewModel.h"
#import "NetworkFetcher+Group.h"

@interface CouponCommentDetailViewModel ()
@property (nonatomic, strong) RACSignal *commentSignal;
@end

@implementation CouponCommentDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.commentSignal = RACObserve(self, commentString);
        self.commentSuccessObject = [RACSubject subject];
        self.commentFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.imageArray = [[NSMutableArray alloc] init];
        self.score = @5;
        
    }
    return self;
}

- (void)sendCommentWithOrderID:(NSString *)orderID
                      couponID:(NSString *)couponID
                       storeID:(NSString *)storeID {
    
    
    if (self.imageArray.count > 0) {
        [NetworkFetcher groupUploadImageArray:self.imageArray success:^(NSDictionary *response) {
            
            if ([response[@"state"] isEqualToString:@"SUCCESS"]) {
    
                
                NSArray *pictureURLArray = [NSString mj_objectArrayWithKeyValuesArray:response[@"url"]];
                
                [NetworkFetcher groupSendCommentWithOrderID:orderID storeID:storeID couponID:couponID score:self.score content:self.commentString pictureURLArray:pictureURLArray success:^(NSDictionary *response) {
                    
                    if ([response[@"errCode"] isEqualToNumber:@0]) {
                        [self.commentSuccessObject sendNext:@"评价成功"];
                    }
                    else {
                        [self.commentSuccessObject sendNext:@"评价失败"];
                    }
                } failure:^(NSString *error) {
                    [self.errorObject sendNext:@"网络异常"];
                }];
            }
            else {
                [self.commentFailureObject sendNext:@"评价失败"];
            }
        } failure:^(NSString *error) {
            [self.errorObject sendNext:@"网络异常"];
        }];
    }
    else {
        [NetworkFetcher groupSendCommentWithOrderID:orderID storeID:storeID couponID:couponID score:self.score content:self.commentString pictureURLArray:nil success:^(NSDictionary *response) {
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                [self.commentSuccessObject sendNext:@"评价成功"];
            }
            else {
                [self.commentSuccessObject sendNext:@"评价失败"];
            }
        } failure:^(NSString *error) {
            [self.errorObject sendNext:@"网络异常"];
        }];
    }

}

@end
