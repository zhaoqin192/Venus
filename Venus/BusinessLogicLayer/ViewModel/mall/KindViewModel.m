//
//  KindViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "KindViewModel.h"
#import "NetworkFetcher+Mall.h"
#import "MerchandiseModel.h"

@interface KindViewModel ()

@property (nonatomic, assign) NSInteger capacity;

@end

@implementation KindViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.kindSuccessObject = [RACSubject subject];
        self.kindFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.capacity = 10;
        self.currentPage = 1;
        self.totalPage = 1;
        self.sort = @1;
    }
    return self;
}

- (void)fetchKindArrayWithIdentifier:(NSString *)identifier
                                page:(NSInteger)page
                                sort:(NSNumber *)sort {
    
    @weakify(self)
    [NetworkFetcher mallGetKindArrayWithIdentifier:identifier page:[NSNumber numberWithInteger:page] capacity:[NSNumber numberWithInteger:self.capacity] sort:sort success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [MerchandiseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"brandID",
                         @"pictureURL": @"picUrl",
                         @"detailURL": @"url",
                         @"price": @"discount"
                        };
            }];
            
            @strongify(self)
            
            self.currentPage = [response[@"page"] integerValue];
            self.totalPage = [response[@"pagination"] integerValue];
            
            self.merchandiseArray = [MerchandiseModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
            [self.kindSuccessObject sendNext:nil];
            
        }
        
        
    } failure:^(NSString *error) {
        
    }];
    
}

- (void)loadMoreKindArrayWithIdentifier:(NSString *)identifier
                                   page:(NSInteger)page
                                   sort:(NSNumber *)sort {
    
    @weakify(self)
    [NetworkFetcher mallGetKindArrayWithIdentifier:identifier page:[NSNumber numberWithInteger:page] capacity:[NSNumber numberWithInteger:self.capacity] sort:sort success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [MerchandiseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"brandID",
                         @"pictureURL": @"picUrl",
                         @"detailURL": @"url",
                         @"price": @"discount"
                         };
            }];
            
            @strongify(self)
            
            self.currentPage = [response[@"page"] integerValue];
            self.totalPage = [response[@"pagination"] integerValue];
            
            [self.merchandiseArray addObjectsFromArray:[MerchandiseModel mj_objectArrayWithKeyValuesArray:response[@"items"]]];
            [self.kindSuccessObject sendNext:nil];
            
        }
        
    } failure:^(NSString *error) {
        
    }];
    
}


@end
