//
//  SearchHomeViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchHomeViewModel.h"
#import "NetworkFetcher+Mall.h"
#import "NSString+Expand.h"
#import "SearchHomeModel.h"


@implementation SearchHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.searchSuccessObject = [RACSubject subject];
        self.searchFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)searchWithKeywords:(NSString *)keywords {
    
    [NetworkFetcher mallSearchWithKeywords:keywords success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [SearchHomeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"pirtureURL": @"logo"
                         };
            }];
            
            self.searchArray = [SearchHomeModel mj_objectArrayWithKeyValuesArray:response[@"brands"]];
            
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
