//
//  SearchHomeViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHomeViewModel : NSObject

@property (nonatomic, strong) RACSubject *searchSuccessObject;
@property (nonatomic, strong) RACSubject *searchFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *searchArray;

- (void)searchWithKeywords:(NSString *)keywords;

@end
