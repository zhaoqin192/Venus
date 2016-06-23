//
//  CouponDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponModel;

@interface CouponDetailViewModel : UITableViewCell

@property (nonatomic, strong) RACSubject *detailSuccessObject;
@property (nonatomic, strong) RACSubject *detailFailureObject;
@property (nonatomic, strong) RACSubject *commentSuccessObject;
@property (nonatomic, strong) RACSubject *commentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSString *useRule;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic ,strong) NSNumber *totalComment;
@property (nonatomic, assign) BOOL backable;
@property (nonatomic, assign) BOOL mustOrder;
@property (nonatomic, strong) NSNumber *type;//1是“套餐劵”，0是“代金券”
@property (nonatomic, strong) NSString *moreDetailurl;//更多图文详情url；
@property (nonatomic, strong) CouponModel *couponModel;

- (void)fetchDetailWithCouponID:(NSString *)couponID;

- (void)fetchCommentWithCouponID:(NSString *)couponID
                            page:(NSNumber *)page;

- (void)loadMoreCommentWithCouponID:(NSString *)couponID
                               page:(NSNumber *)page;


@end
