//
//  NetworkFetcher+FoodOrder.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher+FoodOrder.h"
#import "FoodOrder.h"

@implementation NetworkFetcher (FoodOrder)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = YES;

+ (void)foodFetcherUserFoodOrderOnPage:(NSInteger)page
                               success:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/order/getByCustomer"]];
    
    NSDictionary *parameters = @{@"page": @(page)};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(nil);
    }];
    
}

+ (void)foodCreateOrder:(FoodOrder *)order
                success:(NetworkFetcherSuccessHandler)success
                failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/order/create"]];
    NSDictionary *parameters = @{@"storeId":@([order.storeID longValue]),
                                 @"recipient":order.recipient,
                                 @"address":order.address,
                                 @"contact":order.phoneNumber,
                                 @"remark":order.remark,
                                 @"payStatus":@(order.payStatus),
                                 @"arriveTime":@(order.arriveTime),
                                 @"goodsDetail":order.foodDetail
                                 };
    

    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(nil);
    }];
}

+ (void)foodAlipayWithOrderID:(long)orderID
                      success:(NetworkFetcherSuccessHandler)success
                      failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/order/aliPay"]];
    
    NSDictionary *parameters = @{@"orderId": @(orderID)};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(nil);
    }];
    
}

@end
