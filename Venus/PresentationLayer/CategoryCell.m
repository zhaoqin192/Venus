//
//  CategoryCell.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "CategoryCell.h"
@interface CategoryCell ()

@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.layer.borderWidth = 1;
    self.contentLabel.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
}

@end
