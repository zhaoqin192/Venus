//
//  ShopCommitCell.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopCommitCell.h"
#import "Commit.h"

@interface ShopCommitCell ()
@property (weak, nonatomic) IBOutlet GMLabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ShopCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    self.lineView.backgroundColor = GMBgColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.dateLabel setTextColor:GMTipFontColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFoodModel:(Commit *)foodModel {
    _foodModel = foodModel;
    self.userName.text = foodModel.userName;
    self.contentLabel.text = foodModel.content;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:foodModel.headImg]];
}

@end
