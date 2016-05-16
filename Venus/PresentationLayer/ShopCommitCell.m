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

@end

@implementation ShopCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
