//
//  PlaceHolderTextView.m
//  Venus
//
//  Created by EdwinZhou on 16/6/13.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "PlaceHolderTextView.h"

@interface PlaceHolderTextView()

@property (nonatomic, strong) UILabel *placeLable;

@end

@implementation PlaceHolderTextView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        placeLabel.numberOfLines = 0;
        placeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placeLabel];
        self.placeLable = placeLabel;
        self.font = [UIFont systemFontOfSize:16.0];
        self.placeholderColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeLable.text = _placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeLable.textColor = _placeholderColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect temp = _placeLable.frame;
    temp.origin.y = 8.0f;
    temp.origin.x = 5.0f;
    temp.size.width = self.frame.size.width - 2 * temp.origin.x;
    CGSize size = [self.placeLable sizeThatFits:CGSizeMake(temp.size.width, MAXFLOAT)];
    self.placeLable.frame = CGRectMake(5, 8, temp.size.width,size.height);
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeLable.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged];
}

- (void)textChanged {
    if (self.text.length == 0) {
        self.placeLable.hidden = NO;
    } else {
        self.placeLable.hidden = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
