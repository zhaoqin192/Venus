//
//  HomeNewsCell.m
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "HomeNewsCell.h"
#import "HeadlineModel.h"
#import "MarqueeLabel.h"

@implementation HomeNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showHeadline {
    
    //获取文本
    NSString *string = [[NSString alloc] init];
    for (HeadlineModel *headline in self.headlineArray) {
        string = [string stringByAppendingString:headline.title];
        string = [string stringByAppendingString:@"   "];
    }

    self.marqueeLabel.marqueeType = MLContinuous;
//    self.marqueeLabel.scrollDuration = 15.0f;
//    self.marqueeLabel.rate = 10;
    self.marqueeLabel.text = string;
//    [self.marqueeLabel labelWillBeginScroll];
}

@end
