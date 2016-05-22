//
//  BeautifulCommitView.m
//  Venus
//
//  Created by 王霄 on 16/5/22.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautifulCommitView.h"
@interface BeautifulCommitView ()
@property (weak, nonatomic) IBOutlet UIImageView *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BeautifulCommitView

- (void)awakeFromNib {
    self.textField.backgroundColor = GMBgColor;
    self.sendButton.userInteractionEnabled = YES;
    [self.sendButton bk_whenTapped:^{
        if (self.sendButtonTapped) {
            self.sendButtonTapped();
        }
    }];
}

+ (instancetype)commitView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
