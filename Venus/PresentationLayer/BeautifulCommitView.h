//
//  BeautifulCommitView.h
//  Venus
//
//  Created by 王霄 on 16/5/22.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautifulCommitView : UIView
+ (instancetype) commitView;
@property (nonatomic, copy) void(^sendButtonTapped)();
@end
