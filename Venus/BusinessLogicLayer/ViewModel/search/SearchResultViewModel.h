//
//  SearchResultViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultViewModel : NSObject

@property (nonatomic, strong) RACSubject *searchSuccessObject;
@property (nonatomic, strong) RACSubject *searchFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSNumber *totalPage;



- (void)searchWithKeyword:(NSString *)keyword
                     page:(NSNumber *)page;

@end
