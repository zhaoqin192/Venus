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


@interface SearchResultViewModel ()

@property (nonatomic, strong) NSNumber *capacity;

@end

@implementation SearchResultViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.searchSuccessObject = [RACSubject subject];
        self.searchFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.currentPage = @1;
        self.totalPage = @1;
        self.capacity = @10;
    }
    return self;
}
- (void)searchWithKeyword:(NSString *)keyword
                     page:(NSNumber *)page {
    
    @weakify(self)
    [NetworkFetcher mallSearchWithKeywords:keyword page:page capacity:self.capacity success:^(NSDictionary *response) {
        @strongify(self)
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
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}


@end
