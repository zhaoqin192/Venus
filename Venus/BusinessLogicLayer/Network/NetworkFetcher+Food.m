//
//  NetworkFetcher+Food.m
//  Venus
//
//  Created by zhaoqin on 4/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher+Food.h"
#import "AFNetworking.h"
#import "NetworkManager.h"
#import "FoodManager.h"
#import "FoodClass.h"
#import "MJExtension.h"
#import "Restaurant.h"
#import "ResFoodClass.h"
#import "ResFood.h"
#import "Comment.h"
#import "CommentManager.h"


@implementation NetworkFetcher (Food)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = NO;

+ (void)foodFetcherClassWithSuccess:(NetworkFetcherCompletionHandler)success
                            failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/store/listCat"]];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            [FoodClass mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"id"
                         };
            }];
            FoodManager *foodManager = [FoodManager sharedInstance];
            foodManager.foodClassArray = [FoodClass mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            FoodClass *allOption = [[FoodClass alloc] init];
            allOption.identifier = @"0";
            allOption.name = @"全部";
            
            [foodManager.foodClassArray insertObject:allOption atIndex:0];

            success();
        }else{
            failure(@"请求失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];

}


+ (void)foodFetcherRestaurantWithClass:(FoodClass *)foodClass
                                  sort:(NSString *)sort
                                  page:(NSString *)page
                               success:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure {

    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/store/getByCat"]];
    NSDictionary *parameters = @{@"catId": @(0), @"sort": sort, @"page": @(1)};
//    NSDictionary *parameters = @{@"catId": foodClass.identifier, @"sort": sort, @"page": page};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            [Restaurant mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"id",
                         @"pictureUrl": @"icon",
                         @"basePrice": @"base_price",
                         @"packFee": @"pack_fee",
                         @"costTime": @"cost_time",
                         @"describer": @"description"
                         };
            }];
            foodClass.restaurantArray = [Restaurant mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            success(responseObject);
        }else{
            failure(@"请求失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];

}

+ (void)foodFetcherRestaurantListWithID:(NSString *)restaurantID
                                   sort:(NSString *)sort
                                success:(NetworkFetcherCompletionHandler)success
                                failure:(NetworkFetcherErrorHandler)failure {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/good/list"]];
    
    NSDictionary *parameters = @{@"storeId": restaurantID, @"sort": sort};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            FoodManager *foodManager = [FoodManager sharedInstance];
            [ResFoodClass mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"id",
                         };
            }];
            [ResFood mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"id",
                         @"classID": @"cat_id",
                         @"pictureUrl": @"icon"
                         };
            }];
            
            NSDictionary *data = dic[@"data"];
            foodManager.resFoodClassArray = [ResFoodClass mj_objectArrayWithKeyValuesArray:data[@"category"]];
            foodManager.foodArray = [ResFood mj_objectArrayWithKeyValuesArray:data[@"good"]];
            
            for (ResFoodClass *resFoodClass in foodManager.resFoodClassArray) {
                resFoodClass.foodArray = [[NSMutableArray alloc] init];
                NSString *foodClassId = resFoodClass.identifier;
                for (ResFood *resFood in foodManager.foodArray) {
                    if ([resFood.classID isEqualToString:foodClassId]) {
                        [resFoodClass.foodArray addObject:resFood];
                    }
                }
            }
            
            success();
        }else{
            failure(@"请求失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
}

+ (void)foodFetcherCommentListWithID:(NSString *)restaurantID
                               level:(NSString *)level
                             success:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/comment/getByStore"]];
    
    NSDictionary *parameters = @{@"storeId": restaurantID, @"leval": level};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            [Comment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"commentID": @"id",
                         @"avatar": @"headImg",
                         @"costTime": @"transTime",
                         @"createTime": @"time"
                         };
            }];
            CommentManager *commentManager = [CommentManager sharedManager];
            commentManager.commentArray = [Comment mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            success();
        }else{
            failure(@"请求失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
}

+ (void)foodFetcherRestaurantInfoWithID:(NSNumber *)restaurantID
                                success:(NetworkFetcherSuccessHandler)success
                                failure:(NetworkFetcherErrorHandler)failure {
    
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/miami/customer/store/getInfo"]];
    
    NSDictionary *parameters = @{@"storeId": restaurantID};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];

    
}



@end
