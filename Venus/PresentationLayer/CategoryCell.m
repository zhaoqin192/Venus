//
//  CategoryCell.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "CategoryCell.h"
@interface CategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.layer.borderWidth = 1;
    self.contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
