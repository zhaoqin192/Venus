//
//  ReusableView.m
//  PlainLayout
//
//  Created by hebe on 15/7/30.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(15, 9, frame.size.width, 14)];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 31, frame.size.width, 1)];
//        line.backgroundColor = [UIColor yellowColor];
//        [self addSubview:line];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    ((UILabel *)self.subviews[0]).text = text;
}

@end
