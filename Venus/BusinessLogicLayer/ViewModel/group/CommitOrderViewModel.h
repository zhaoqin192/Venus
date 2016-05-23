//
//  CommitOrderViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitOrderViewModel : NSObject

@property (nonatomic, assign) NSInteger countNumber;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) RACSubject *countObject;
@property (nonatomic, assign) NSInteger selectPay;
@property (nonatomic, assign) BOOL isSelected;

- (void)initPrice:(NSNumber *)price;

- (void)addCount;

- (void)subtractCount;

- (id)commitButtonIsValid;

@end
