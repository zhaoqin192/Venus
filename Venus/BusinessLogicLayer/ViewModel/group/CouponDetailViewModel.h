//
//  CouponDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponDetailViewModel : UITableViewCell

//@property (nonatomic, strong) RACSubject *detailSuccessObject;
//@property (nonatomic, strong) RACSubject *detailFailureObject;
@property (nonatomic, strong) RACSubject *commentSuccessObject;
@property (nonatomic, strong) RACSubject *commentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *commentArray;

//- (void)fetchDetailWithCouponID:(NSString *)couponID;

- (void)fetchCommentWithCouponID:(NSString *)couponID
                            page:(NSNumber *)page;

- (void)loadMoreCommentWithCouponID:(NSString *)couponID
                               page:(NSNumber *)page;


@end
