//
//  MapHeadView.h
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapHeadView : UIView
+ (instancetype)headView;
@property (nonatomic, copy) void(^newsLabelTapped)();
@property (nonatomic, copy) void(^discountLabelTapped)();
@end
