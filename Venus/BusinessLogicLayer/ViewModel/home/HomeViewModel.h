//
//  HomeViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

typedef enum ADVERTISEMENT_TYPE {
    UNISHOP,//通用店铺
    SHOP,//品牌店铺
    ITEM,//购物单品
    COUPON,//团购
    FOOD,//外卖
    WEB//网页
}ADVERTISEMENT_TYPE;

@property (nonatomic, strong) RACSubject *loginSuccessObject;
@property (nonatomic, strong) RACSubject *loginFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) RACSubject *headlineSuccessObject;
@property (nonatomic, strong) RACSubject *headlineFailureObject;
@property (nonatomic, strong) NSMutableArray *headlineArray;
@property (nonatomic, assign) ADVERTISEMENT_TYPE type;
@property (nonatomic, strong) NSString *typeID;

- (void)login;

- (void)fetchHeadline;

- (void)parseURL:(NSString *)url;

@end
