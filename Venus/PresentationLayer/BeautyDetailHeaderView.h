//
//  BeautyDetailHeaderView.h
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeautifulFood;
@interface BeautyDetailHeaderView : UIView
@property (nonatomic, strong) BeautifulFood *foodModel;
@property (nonatomic, copy) void(^returnButtonClicked)();
@property (nonatomic, copy) void(^segmentButtonClicked)(NSInteger index);
@property (nonatomic, assign) BOOL isNoWaiView;
@property (nonatomic, copy) void(^waiViewTapped)();
+ (instancetype)headView;

@end
