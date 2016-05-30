//
//  SearchResultViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchResultViewModel.h"
#import "NetworkFetcher+Mall.h"
#import "NSString+Expand.h"
#import "SearchResultModel.h"

@implementation SearchResultViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.searchSuccessObject = [RACSubject subject];
        self.searchFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)searchWithKeyword:(NSString *)keyword {
    
    [NetworkFetcher mallSearchWithKeywords:keyword success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [SearchResultModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"shopId",
                         @"pictureURL": @"logo",
                         @"name": @"shopName"
                         };
            }];
            
            self.searchArray = [SearchResultModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            
            [self.searchSuccessObject sendNext:nil];
            
        }
        else {
            
            [self.searchFailureObject sendNext:@"搜索失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];
    
}


@end
