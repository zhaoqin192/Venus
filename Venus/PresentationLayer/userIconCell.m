//
//  userIconCell.m
//  Mercurial
//
//  Created by 王霄 on 16/4/5.
//  Copyright © 2016年 muggins. All rights reserved.
//

#import "userIconCell.h"

@interface userIconCell ()

@end

@implementation userIconCell

- (void)awakeFromNib{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.myImageView.layer.cornerRadius = self.myImageView.width/2;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
}

//- (void)setIconUrl:(NSString *)iconUrl{
//    _iconUrl = iconUrl;
//    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:self.iconUrl] placeholderImage:[UIImage imageNamed:@"iconholder"] completed:nil];
//}

@end
