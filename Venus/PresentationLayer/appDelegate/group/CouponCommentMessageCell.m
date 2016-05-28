//
//  CouponCommentMessageCell.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentMessageCell.h"

@interface CouponCommentMessageCell ()<UITextViewDelegate>

@end

@implementation CouponCommentMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contentChanged" object:nil userInfo:@{@"content": self.textView.text}];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
