//
//  KindViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindViewModel : NSObject

@property (nonatomic, strong) RACSubject *kindSuccessObject;
@property (nonatomic, strong) RACSubject *kindFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *merchandiseArray;


- (void)fetchKindArrayWithIdentifier:(NSString *)identifier
                                page:(NSInteger)page
                                sort:(NSNumber *)sort;

@end
