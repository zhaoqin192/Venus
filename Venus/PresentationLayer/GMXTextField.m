//
//  GMXTextField.m
//  Venus
//
//  Created by 王霄 on 16/4/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMXTextField.h"

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation GMXTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setTextColor:GMBgColor];
    self.tintColor = GMBrownColor;
    [self setValue:GMBgColor forKeyPath:XMGPlacerholderColorKeyPath];
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    [self setValue:GMBgColor forKeyPath:XMGPlacerholderColorKeyPath];
}

- (BOOL)becomeFirstResponder{
    [self setValue:GMBrownColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    [self setValue:GMBgColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

@end
