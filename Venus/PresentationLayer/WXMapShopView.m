//
//  WXMapShopView.m
//  Venus
//
//  Created by 王霄 on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXMapShopView.h"

@interface WXMapShopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet GMButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation WXMapShopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _goButton.layer.borderWidth = 1;
        _goButton.layer.borderColor = GMBrownColor.CGColor;
    }
    return self;
}

@end
