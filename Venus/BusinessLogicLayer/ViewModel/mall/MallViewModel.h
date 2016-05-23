//
//  MallViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MallCategoryModel;

@interface MallViewModel : NSObject

@property (nonatomic, strong) RACSubject *categorySuccessObject;
@property (nonatomic, strong) RACSubject *categoryFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) MallCategoryModel *categoryModel;

- (void)fetchCategory;

- (void)cacheData;

@end
