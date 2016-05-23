//
//  CommitOrderViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CommitOrderViewModel.h"

@interface CommitOrderViewModel ()

@property (nonatomic, strong) RACSignal *countSignal;
@end


@implementation CommitOrderViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.countNumber = 0;
        self.countObject = [RACSubject subject];
        self.countSignal = RACObserve(self, self.countNumber);
    }
    return self;
}

- (id)commitButtonIsValid {
    
    RACSignal *isValid = [RACSignal combineLatest:@[self.countSignal] reduce:^id{
        
        return @(self.countNumber > 0);
    }];
    
    return isValid;
}

- (void)initPrice:(NSNumber *)price {
    self.price = [price integerValue];
}

- (void)addCount {
    
    self.countNumber++;
    self.totalPrice = self.countNumber * self.price;
    [self.countObject sendNext:nil];
    
}

- (void)subtractCount {
    
    if (self.countNumber == 0) {
        return;
    }
    
    self.countNumber--;
    self.totalPrice = self.countNumber * self.price;
    [self.countObject sendNext:nil];
    
}


@end
