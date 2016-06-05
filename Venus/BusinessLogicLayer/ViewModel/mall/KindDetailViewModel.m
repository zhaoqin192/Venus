//
//  KindDetailViewModel.m
//  Venus
//
//  Created by zhaoqin on 6/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "KindDetailViewModel.h"
#import "NetworkFetcher+Mall.h"


@implementation KindDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailSuccessObject = [RACSubject subject];
        self.detailFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchDetailWithID:(NSNumber *)identifier {
    @weakify(self)
    [NetworkFetcher mallFetchKindDetailWithID:identifier success:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            NSDictionary *item = response[@"item"];
            self.headImage = item[@"img"];
            self.marketPrice = item[@"price"];
            self.price = item[@"discount"];
            self.itemName = item[@"item_name"];
            [self.detailSuccessObject sendNext:nil];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}


@end
