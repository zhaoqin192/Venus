//
//  MallViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/20/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "MallViewModel.h"
#import "AppCacheManager.h"
#import "NetworkFetcher+Mall.h"
#import "MallCategoryModel.h"
#import "MallBrandModel.h"
#import "MallKindModel.h"
#import "MJExtension.h"

@implementation MallViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.categorySuccessObject = [RACSubject subject];
        self.categoryFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchCategory {
    
    self.categoryArray = [AppCacheManager fetchCacheDataWithFileName:@"MallCategory"];
    
    if (self.categoryArray != nil) {
        [self.categorySuccessObject sendNext:nil];
    }
    
    [NetworkFetcher mallGetCategoryWithSuccess:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [MallCategoryModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"info.id",
                            @"name": @"info.name",
                            @"brandArray": @"brands",
                            @"kindArray": @"class_2"
                         };
            }];
            
            [MallBrandModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"pictureURL": @"pic",
                            @"detailURL": @"murl"
                         };
            }];
            
            [MallKindModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"info.id",
                            @"name": @"info.name",
                            @"pictureURL": @"info.pic"
                         };
            }];
            
            [MallCategoryModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                            @"brandArray": @"MallBrandModel",
                            @"kindArray": @"MallKindModel"
                         };
            }];
            
            self.categoryArray = [MallCategoryModel mj_objectArrayWithKeyValuesArray:response[@"class_1"]];
            [self.categorySuccessObject sendNext:nil];
        }
        
        
    } failure:^(NSString *error) {
        
    }];
    
}

- (void)cacheData {
    [AppCacheManager cacheDataWithData:self.categoryArray fileName:@"MallCategory"];
}



@end
