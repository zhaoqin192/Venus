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

@implementation HomeViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.loginSuccessObject = [RACSubject subject];
        self.loginFailureObject = [RACSubject subject];
        self.headlineSuccessObject = [RACSubject subject];
        self.headlineFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}


- (void)login {
    
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if (account.phone == nil || account.password == nil) {
        [self.loginFailureObject sendNext:nil];
    }
    else {
        [NetworkFetcher userLoginWithAccount:account.phone password:account.password success:^(NSDictionary *response) {
            if ([response[@"errCode"] isEqualToNumber:@0]) {
                AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
                Account *account = [accountDao fetchAccount];
                account.token = response[@"userid"];
                [accountDao save];
                accountDao.isLogin = YES;
            }
        } failure:^(NSString *error) {
            [_errorObject sendNext:@"网络异常"];
        }];
        
    }
    
}

- (void)fetchHeadline {
    
    [NetworkFetcher homeFetcherHeadlineArrayWithSuccess:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            [HeadlineModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"abstract": @"summary"
                         };
            }];
            self.headlineArray = [HeadlineModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            [self.headlineSuccessObject sendNext:nil];
        }
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)parseURL:(NSString *)url {
    //匹配通用店铺
    NSString *pattern = @"uniShop";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSTextCheckingResult *firstMatch = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if (firstMatch) {
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        NSString *identifier = [url substringWithRange:NSMakeRange(resultRange.location + resultRange.length + 1, url.length - resultRange.location - resultRange.length - 1)];
        self.type = UNISHOP;
        self.typeID = identifier;
        return;
    }
    
    //匹配品牌店铺
    pattern = @"shop";
    regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    firstMatch = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if (firstMatch) {
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        NSString *identifier = [url substringWithRange:NSMakeRange(resultRange.location + resultRange.length + 1, url.length - resultRange.location - resultRange.length - 1)];
        self.type = SHOP;
        self.typeID = identifier;
        return;
    }
    
    //匹配购物单品
    pattern = @"item";
    regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    firstMatch = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if (firstMatch) {
        NSString *type = [url substringWithRange:NSMakeRange(url.length - 1, 1)];
        if ([type isEqualToString:@"2"]) {
            self.type = WEB;
            return;
        }
        pattern = @"[0-9]{5,}";
        regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSTextCheckingResult *second = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
        if (second) {
            NSRange resultRange = [second rangeAtIndex:0];
            NSString *identifier = [url substringWithRange:NSMakeRange(resultRange.location, resultRange.length)];
            self.type = ITEM;
            self.typeID = identifier;
            return;
        }
    }
    
    //匹配团购
    pattern = @"couponz";
    regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    firstMatch = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if (firstMatch) {
        self.type = COUPON;
        self.typeID = [self fetchUrlParam:@"couponId" url:url];
        return;
    }
    
    //匹配外卖
    pattern = @"storeIndex";
    regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    firstMatch = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    if (firstMatch) {
        pattern = @"[0-9]{5,}";
        regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSTextCheckingResult *second = [regular firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
        if (second) {
            NSRange resultRange = [second rangeAtIndex:0];
            NSString *identifier = [url substringWithRange:NSMakeRange(resultRange.location, resultRange.length)];
            self.type = FOOD;
            self.typeID = identifier;
            return;
        }
    }
    self.type = WEB;
}

-(NSString *)fetchUrlParam:(NSString *)param url:(NSString *)url {
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        return [url substringWithRange:[match rangeAtIndex:2]];
    }
    return nil;
}

//- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
//    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
//    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
//    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
//    while (![scanner isAtEnd]) {
//        NSString* pairString = nil;
//        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
//        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
//        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
//        if (kvPair.count == 2) {
//            NSString* key = [[kvPair objectAtIndex:0]
//                             stringByReplacingPercentEscapesUsingEncoding:encoding];
//            NSString* value = [[kvPair objectAtIndex:1]
//                               stringByReplacingPercentEscapesUsingEncoding:encoding];
//            [pairs setObject:value forKey:key];
//        }
//    }
//    
//    return [NSDictionary dictionaryWithDictionary:pairs];
//}


@end
