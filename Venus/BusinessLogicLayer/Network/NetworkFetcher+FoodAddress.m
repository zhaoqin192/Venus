//
//  NetworkFetcher+FoodAddress.m
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NetworkFetcher+FoodAddress.h"
#import "FoodAddress.h"
#import "FoodAddressManager.h"

@implementation NetworkFetcher (FoodAddress)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = YES;

+ (void)foodFetcherUserFoodAddresWithRestaurantID:(NSString *)restaurantID
                                          success:(NetworkFetcherCompletionHandler)success
                                          failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/order/getAddress"]];
    
    NSDictionary *parameters = @{@"storeId": restaurantID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            FoodAddressManager *addressManager = [FoodAddressManager sharedInstance];
            [FoodAddress mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"addressID": @"addressid",
                         @"linkmanName": @"name",
//                         @"address": @"address",
                         @"phoneNumber": @"phone",
                         };
            }];
            addressManager.foodAddressArray = [FoodAddress mj_objectArrayWithKeyValuesArray:dic[@"address"]];
            addressManager.userID = dic[@"uid"];
            success();
        }else {
            failure(@"请求失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        NSLog(@"%@", error);
        failure(@"网络异常");
    }];
}

+ (void)addUserFoodAddress:(FoodAddress *)foodAddress
                   success:(NetworkFetcherCompletionHandler)success
                   failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/order/setAddress"]];
    NSDictionary *parameters = @{@"name":foodAddress.linkmanName, @"address":foodAddress.address, @"phone":foodAddress.phoneNumber};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        if ([dic[@"errCode"] isEqualToNumber:@0]) {
            success();
        } else {
            failure(dic[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        
        failure(@"网络异常");
    }];
}

+ (void)EditUserFoodAddress:(FoodAddress *)foodAddress
                    success:(NetworkFetcherCompletionHandler)success
                    failure:(NetworkFetcherErrorHandler)failure {
    return;
}

+ (void)DeleteUserFoodAddress:(FoodAddress *)foodAddress
                      success:(NetworkFetcherCompletionHandler)success
                      failure:(NetworkFetcherErrorHandler)failure {
    return;
}

@end
