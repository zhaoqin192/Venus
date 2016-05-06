//
//  Restaurant.h
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *sales;
@property (nonatomic, copy) NSString *basePrice;
@property (nonatomic, copy) NSString *packFee;
@property (nonatomic, copy) NSString *costTime;
@property (nonatomic, copy) NSString *describer;


@end
