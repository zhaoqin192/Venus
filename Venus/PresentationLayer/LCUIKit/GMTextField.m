//
//  GMTextField.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMTextField.h"

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation GMTextField

- (void)setLineView:(UIView *)lineView{
    _lineView = lineView;
    self.lineView.backgroundColor = GMTipFontColor;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:self.imageName];
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    [self setValue:GMTipFontColor forKeyPath:XMGPlacerholderColorKeyPath];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:GMBrownColor forKeyPath:XMGPlacerholderColorKeyPath];
    self.lineView.backgroundColor = GMBrownColor;
    self.tintColor = GMBrownColor;
    self.imageView.image = [UIImage imageNamed:self.selectImageName];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:GMTipFontColor forKeyPath:XMGPlacerholderColorKeyPath];
    self.lineView.backgroundColor = GMTipFontColor;
    self.tintColor = GMTipFontColor;
    self.imageView.image = [UIImage imageNamed:self.imageName];
    return [super resignFirstResponder];
}

@end
