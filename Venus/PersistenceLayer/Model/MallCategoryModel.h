//
//  MallCategoryModel.h
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallCategoryModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *brandArray;
@property (nonatomic, strong) NSMutableArray *kindArray;

@end
