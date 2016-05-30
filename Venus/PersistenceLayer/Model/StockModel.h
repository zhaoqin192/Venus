//
//  StockModel.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *code;
//0未使用，1过期，2已使用，3退款中，4退款成功，5退款失败
@property (nonatomic, strong) NSNumber *status;

@end
