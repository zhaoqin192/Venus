//
//  HomeCategoryCell.m
//  Venus
//
//  Created by 王霄 on 16/4/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "HomeCategoryCell.h"
#import "Adversitement.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "Picture.h"

@implementation HomeCategoryCell

static const NSString *PICTUREURL = @"http://www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData {
    self.title.text = self.adversitement.name;
    [self.mainPicture sd_setImageWithURL:[NSURL URLWithString:[PICTUREURL stringByAppendingString:self.adversitement.pictureUrl]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    
    
    for (int i = 0; i < self.adversitement.advertisementArray.count; i++) {
        Picture *picture = self.adversitement.advertisementArray[i];
        if ([[self.contentView viewWithTag:i + 1] isKindOfClass:[UIButton class]]) {
            UIButton *button = [self.contentView viewWithTag:i + 1];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[PICTUREURL stringByAppendingString:picture.pictureUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default"]];
            
            
            
            [button addTarget:self action:@selector(sendNotification:) forControlEvents:UIControlEventTouchUpInside];
            if (i > 1) {
                UILabel *label = [self.contentView viewWithTag:i + 11];
                label.text = picture.name;
            }
        }
    }
}

- (void)sendNotification:(UIButton*)sender {
    NSInteger index = sender.tag - 1;
    Picture *picture = [self.adversitement.advertisementArray objectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAdvertisement" object:nil userInfo:@{@"advertisementURL": picture.url}];
}

@end
