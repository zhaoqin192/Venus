//
//  BeautyDetailHeaderView.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautyDetailHeaderView.h"

@implementation BeautyDetailHeaderView

+ (instancetype)headView {
    BeautyDetailHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BeautyDetailHeaderView class]) owner:nil options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (IBAction)returnButtonClicked:(id)sender {
    if (self.returnButtonClicked) {
        self.returnButtonClicked();
    }
}

@end
