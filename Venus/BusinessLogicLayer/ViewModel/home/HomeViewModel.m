//
//  HomeViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "HomeViewModel.h"
#import "NetworkFetcher+User.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "NetworkFetcher+Home.h"
#import "HeadlineModel.h"
#import "Picture.h"
#import "Adversitement.h"

static const NSString *URL_OF_USER_PREFIX = @"http://www.chinaworldstyle.com";
static const NSString *PICTUREURL = @"http://www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";

@implementation HomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.loopPicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
                NSDictionary *parameters = @{@"picType": @1, @"owner": @1};
                
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if([responseObject[@"errCode"] isEqualToNumber:@0]){
                        self.loopPicArray = [Picture mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                        self.scrollURLArray = [[NSMutableArray alloc] init];
                        for (Picture *picture in self.loopPicArray) {
                            NSString *urlPath = [PICTUREURL stringByAppendingString:picture.pictureUrl];
                            [self.scrollURLArray addObject:urlPath];
                        }
                    }
                    [subscriber sendNext:responseObject[@"errCode"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.headlineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/QuickNews/getAll"]];
                NSDictionary *parameters = @{@"page": @1, @"contentNum": @5};
                
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                        [HeadlineModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"identifier": @"id",
                                     @"abstract": @"summary"
                                     };
                        }];
                        self.headlineArray = [HeadlineModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                    }
                    [subscriber sendNext:responseObject[@"errCode"]];
                    [subscriber sendCompleted];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
            
        }];
        
        self.recommandCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
                NSDictionary *parameters = @{@"picType": @2, @"owner": @1};
                
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                        self.recommandArray = [Picture mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                        self.recommandURLArray = [[NSMutableArray alloc] init];
                        for (Picture *picture in self.recommandArray) {
                            NSString *urlPath = [PICTUREURL stringByAppendingString:picture.pictureUrl];
                            [self.recommandURLArray addObject:urlPath];
                        }
                    }
                    [subscriber sendNext:responseObject[@"errCode"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.boutiqueCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
                NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/carousel/get"]];
                NSDictionary *parameters = @{@"picType": @5, @"owner": @1};
                [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject[@"errCode"] isEqualToNumber:@0]) {
                        self.boutiqueArray = [Picture mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                        self.boutiqueURLArray = [[NSMutableArray alloc] init];
                        for (Picture *picture in self.boutiqueArray) {
                            [self.boutiqueURLArray addObject:[PICTUREURL stringByAppendingString:picture.pictureUrl]];
                        }
                    }
                    [subscriber sendNext:responseObject[@"errCode"]];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                }];
                return nil;
            }];
        }];
        
        self.advertisementCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
               NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/facew/assemble/wap/getassemble"]];
               NSDictionary *parameters = @{@"owner":@1, @"num":@7};
               [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   if([responseObject[@"errCode"] isEqualToNumber:@0]){
                       [Adversitement mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                           return @{
                                    @"name": @"categoryName",
                                    @"pictureUrl": @"categoryPic",
                                    @"advertisementArray": @"categoryLabelAds.lableAds"
                                    };
                       }];
                       [Picture mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                           return @{
                                    @"name": @"title"
                                    };
                       }];
                       [Adversitement mj_setupObjectClassInArray:^NSDictionary *{
                           return @{
                                    @"advertisementArray": @"Picture"
                                    };
                       }];
                       self.advertisementArray = [Adversitement mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                   }
                   [subscriber sendNext:responseObject[@"errCode"]];
                   [subscriber sendCompleted];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [subscriber sendError:nil];
               }];
               return nil;
           }];
        }];
        
        self.errorObject = [RACSubject subject];
        
        [[RACSignal merge:@[self.headlineCommand.errors, self.loopPicCommand.errors, self.recommandCommand.errors, self.advertisementCommand.errors, self.boutiqueCommand.errors]]
         subscribe:self.errorObject];
    }
    return self;
}


- (void)login {
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if (account.phone != nil && account.password != nil) {
        AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
        NSURL *url = [NSURL URLWithString:[URL_OF_USER_PREFIX stringByAppendingString:@"/terra/loginsubmit"]];
        NSDictionary *parameters = @{@"account": account.phone, @"password": account.password};
        @weakify(manager)
        [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
            NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
            for (NSString *key in cookieHeaders) {
                @strongify(manager)
                NSLog(@"%@", key);
                [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
            }
        } failure:nil];
    }
}


@end
