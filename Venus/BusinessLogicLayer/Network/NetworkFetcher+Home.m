//
//  NetworkFetcher+Home.m
//  Venus
//
//  Created by zhaoqin on 4/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "NetworkFetcher+Home.h"
#import "AFNetworking.h"
#import "NetworkManager.h"
#import "PictureManager.h"
#import "Picture.h"
#import "MJExtension.h"
#import "Adversitement.h"
#import "AdvertisementManager.h"

@implementation NetworkFetcher (Home)

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const BOOL LOGDEBUG = NO;


+ (void)homeFetcherLoopPictureWithSuccess:(NetworkFetcherCompletionHandler)success
                                  failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
    NSDictionary *parameters = @{@"picType": @1, @"owner": @1};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            PictureManager *pictureManager = [PictureManager sharedInstance];
            pictureManager.loopPictureArray = [Picture mj_objectArrayWithKeyValuesArray:dic[@"result"]];
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

+ (void)homeFetcherRecommmendWithSuccess:(NetworkFetcherCompletionHandler)success
                                 failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
    NSDictionary *parameters = @{@"picType": @2, @"owner": @1};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            PictureManager *pictureManager = [PictureManager sharedInstance];
            pictureManager.recommendPictureArray = [Picture mj_objectArrayWithKeyValuesArray:dic[@"result"]];
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

+ (void)homeFetcherListADWithSuccess:(NetworkFetcherCompletionHandler)success
                             failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/assemble/ios/getassemble"]];
    NSDictionary *parameters = @{@"owner": @1};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
        NSDictionary *dic = responseObject;
        
        if([dic[@"errCode"] isEqualToNumber:@0]){
            [Adversitement mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"name": @"categoryName",
                         @"pictureUrl": @"categoryPic",
                         @"advertisementArray": @"categoryLabelAds[0].lableAds"
                         };
            }];
            
            [Picture mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"name": @"title",
                         };
            }];

            [Adversitement mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"advertisementArray": @"Picture"
                         };
            }];
            
            AdvertisementManager *advertisementManager = [AdvertisementManager sharedInstance];
            advertisementManager.advertisementArray = [Adversitement mj_objectArrayWithKeyValuesArray:dic[@"result"]];
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

+ (void)homeFetcherHeadlineArrayWithSuccess:(NetworkFetcherSuccessHandler)success
                                    failure:(NetworkFetcherErrorHandler)failure {

    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/QuickNews/getAll"]];
    NSDictionary *parameters = @{@"page": @1, @"contentNum": @5};
    
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

+ (void)homeFetcherHeadlineDetailWithID:(NSNumber *)identifier
                                success:(NetworkFetcherSuccessHandler)success
                                failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/QuickNews/getById"]];
    NSDictionary *parameters = @{@"id": identifier};
    
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

+ (void)homeFetcherBoutiqueWithSuccess:(NetworkFetcherSuccessHandler)success
                               failure:(NetworkFetcherErrorHandler)failure {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
    NSDictionary *parameters = @{@"picType": @5, @"owner": @1};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (LOGDEBUG) {
            NSLog(@"%@", responseObject);
        }
//        NSDictionary *dic = responseObject;
        
//        if([dic[@"errCode"] isEqualToNumber:@0]){
//            PictureManager *pictureManager = [PictureManager sharedInstance];
//            pictureManager.recommendPictureArray = [Picture mj_objectArrayWithKeyValuesArray:dic[@"result"]];
//            success();
//        }else{
//            failure(@"请求失败");
//        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (LOGDEBUG) {
            NSLog(@"%@", error);
        }
        failure(@"网络异常");
    }];
    
}

@end
