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

@end

@implementation BeautifulCommitView

- (void)awakeFromNib {
    self.textField.backgroundColor = GMBgColor;
    self.sendButton.userInteractionEnabled = YES;
    [self.sendButton bk_whenTapped:^{
        if (self.textField.text.length == 0) {
            [self.textField resignFirstResponder];
            return ;
        }
        if (self.sendButtonTapped) {
            self.sendButtonTapped(self.textField.text);
        }
    }];
}

+ (instancetype)commitView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
