//
//  CommitOrderViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CommitOrderViewModel.h"
#import "NetworkFetcher+Group.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Expand.h"

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
        self.orderSuccessObject = [RACSubject subject];
        self.orderFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (id)commitButtonIsValid {
    
    @weakify(self)
    RACSignal *isValid = [RACSignal combineLatest:@[self.countSignal] reduce:^id{
        @strongify(self)
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

- (void)createOrderWithCouponID:(NSString *)couponID
                        storeID:(NSString *)storeID
                            num:(NSNumber *)num {
    
    @weakify(self)
    [NetworkFetcher groupCreateOrderWithCouponID:couponID storeID:storeID num:num success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            @strongify(self)
            
            self.orderID = [NSString stringWithFormat:@"%@", response[@"orderId"]];
            
            [NetworkFetcher grougPrePayWithOrderID:self.orderID method:@"AliPay" success:^(NSDictionary *response) {
               
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
                    @strongify(self)
                    [self.orderFailureObject sendNext:@"下单失败"];
                }
                
            } failure:^(NSString *error) {
                @strongify(self)
                [self.errorObject sendNext:@"网络请求异常"];
                
            }];
            
        }
        else {
            @strongify(self)
            [self.orderFailureObject sendNext:@"下单失败"];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络请求异常"];
        
    }];
    
}

@end
