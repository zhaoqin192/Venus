//
//  CouponCommentViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponCommentViewModel : NSObject

@property (nonatomic, strong) RACSubject *commentSuccessObject;
@property (nonatomic, strong) RACSubject *commentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *commentArray;

- (void)fetchCommentData;

- (void)cacheData;

- (void)refreshData;



@end
