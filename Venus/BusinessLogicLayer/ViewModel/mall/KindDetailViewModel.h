//
//  KindDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 6/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindDetailViewModel : NSObject

@property (nonatomic, strong) RACSubject *detailSuccessObject;
@property (nonatomic, strong) RACSubject *detailFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSNumber *marketPrice;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, copy) NSString *detailURL;

- (void)fetchDetailWithID:(NSNumber *)identifier;



@end
