//
//  WXCoupon.h
//  Venus
//
//  Created by 王霄 on 16/5/16.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCoupon : NSObject
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, assign) NSInteger asPrice;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger purchaseNum;
@end
