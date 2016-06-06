//
//  WXMapShopView.h
//  Venus
//
//  Created by 王霄 on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXMapShopModel;
@interface WXMapShopView : UIView
@property (nonatomic, strong) WXMapShopModel *model;
@property (nonatomic, copy) void(^goButtonClicked)();
+ (instancetype)shopView;
@end
