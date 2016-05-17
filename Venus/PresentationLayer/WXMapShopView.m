//
//  WXMapShopView.m
//  Venus
//
//  Created by 王霄 on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXMapShopView.h"
#import "WXMapShopModel.h"

@interface WXMapShopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet GMButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation WXMapShopView

- (void)awakeFromNib {
    self.goButton.layer.borderWidth = 1;
    self.goButton.layer.borderColor = GMBrownColor.CGColor;
    self.lineView.backgroundColor = GMBgColor;
}

+ (instancetype)shopView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setModel:(WXMapShopModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.contentLabel.text = model.desp;
}


@end
