//
//  FoodCategoryCell.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodCategoryCell.h"

@interface FoodCategoryCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FoodCategoryCell

- (void)awakeFromNib {
    self.lineView.backgroundColor = GMBrownColor;
    [self.contentLabel setTextColor:[UIColor lightGrayColor]];
    self.contentView.backgroundColor = GMBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.lineView.hidden = NO;
        [self.contentLabel setTextColor:GMBrownColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.lineView.backgroundColor = GMBrownColor;
    }
    else{
        self.lineView.hidden = YES;
        [self.contentLabel setTextColor:[UIColor lightGrayColor]];
        self.contentView.backgroundColor = GMBgColor;
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = content;
}


@end
