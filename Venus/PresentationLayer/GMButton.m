//
//  GMButton.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMButton.h"

@implementation GMButton

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
    [self setTitleColor:GMBrownColor forState:UIControlStateNormal];
}

@end
