//
//  FoodOrderViewSectionObject.h
//  Venus
//
//  Created by EdwinZhou on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodOrderViewSectionObject : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, strong) NSMutableArray *items;

@end
