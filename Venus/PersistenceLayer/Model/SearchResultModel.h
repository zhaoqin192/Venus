//
//  SearchResultModel.h
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSNumber *type;

@end
