//
//  CouponPayViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponPayViewModel.h"
#import "AppCacheManager.h"
#import "NetworkFetcher+Group.h"
#import "MJExtension.h"
#import "CouponOrderModel.h"
#import "Order.h"
#import "NSString+Expand.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation CouponPayViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.paySuccessObject = [RACSubject subject];
        self.payFailureObject = [RACSubject subject];
        self.paymentSuccessObject = [RACSubject subject];
        self.paymentFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchPayData {
    
    self.payArray = [AppCacheManager fetchCacheDataWithFileName:@"CouponPayData"];
    
    if (self.payArray != nil) {
        [self.paySuccessObject sendNext:nil];
    }
    
    [self refreshData];
    
}

- (void)cacheData {
    
    [AppCacheManager cacheDataWithData:self.payArray fileName:@"CouponPayData"];

}

- (void)refreshData {
    
    [NetworkFetcher groupFetchAccountOrderArrayWithStatus:@0 success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponOrderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"orderID": @"orderId",
                         @"accountID": @"wmId",
                         @"storeID": @"storeId",
                         @"couponID": @"couponId",
                         @"pictureURL": @"couponPicUrl",
                         @"endTime": @"couponEndTime",
                         @"resume": @"abstract",
                         @"count": @"num",
                         @"totalPrice": @"price",
                         @"creatTime": @"orderCreateTime"
                         };
            }];
            
            self.payArray = [CouponOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
            [self.paySuccessObject sendNext:nil];
            
        }
        else {
            
            [self.payFailureObject sendNext:@"请求失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];

    
}

- (void)createOrderWithCouponID:(NSString *)couponID
                        storeID:(NSString *)storeID
                            num:(NSNumber *)num {
    
    [NetworkFetcher groupCreateOrderWithCouponID:couponID storeID:storeID num:num success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [NetworkFetcher grougPrePayWithOrderID:response[@"orderId"] method:@"AliPay" success:^(NSDictionary *response) {
                
                if ([response[@"errCode"] isEqualToNumber:@0]) {
                    
                    NSString *privateKey = response[@"sign"];
                    
                    //生成订单信息及签名
                    Order *order = [[Order alloc] init];
                    order.partner = response[@"partner"];
                    order.sellerID = response[@"seller_id"];
                    order.outTradeNO = response[@"out_trade_no"];
                    order.service = response[@"service"];
                    order.inputCharset = response[@"_input_charset"];
                    order.notifyURL = response[@"notify_url"];
                    order.subject = response[@"subject"];
                    order.paymentType = response[@"payment_type"];
                    order.body = response[@"body"];
                    order.totalFee = response[@"total_fee"];
                    
                    NSString *appScheme = @"alipay2088411898385492";
                    //将商品信息拼接成字符串
                    NSString *orderSpec = [order description];
                    
                    //将签名成功字符串格式化为订单字符串,请严格按照该格式
                    NSString *orderString = nil;
                    
                    
                    NSString *urlencoding = [NSString urlEncodedString:privateKey];
                    
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, urlencoding, @"RSA"];
                    
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                    }];
                    
                }
                else {
                    [self.paymentFailureObject sendNext:@"下单失败"];
                }
                
            } failure:^(NSString *error) {
                
                [self.errorObject sendNext:@"网络请求异常"];
                
            }];
            
        }
        else {
            [self.paymentFailureObject sendNext:@"下单失败"];
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络请求异常"];
        
    }];
    
}


@end
