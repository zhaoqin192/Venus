//
//  HomeIntroduceCell.m
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "HomeIntroduceCell.h"
@interface HomeIntroduceCell()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@end

@implementation HomeIntroduceCell

- (void)awakeFromNib {
    _rightLine.backgroundColor = GMBrownColor;
    _leftLine.backgroundColor = GMBrownColor;
}

- (void)setList:(NSMutableArray *)list{
    if (list.count == 0) {
        return;
    }
    CGFloat width = 120;
    CGFloat height = 90;
    CGFloat margin = 5;
    for (int i = 0; i<list.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(margin*i + i*width, 0, width, height);
        button.tag = i;
        button.backgroundColor = [UIColor greenColor];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:button];
        self.myScrollView.contentSize = CGSizeMake((i+1)*(margin+width), 0);
    }
}

- (void)buttonTapped:(UIButton *)button{
    if (self.buttonClicked) {
        self.buttonClicked(button);
    }
}

@end