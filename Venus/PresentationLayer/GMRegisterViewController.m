//
//  GMRegisterViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMRegisterViewController.h"

@interface GMRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation GMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"手机注册"]];
    [self configureUI];
}

- (void)configureUI{
    self.codeButton.layer.cornerRadius = self.codeButton.frame.size.height/2;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton setTitleColor:GMBgColor forState:UIControlStateNormal];
    self.codeButton.layer.borderColor = GMBgColor.CGColor;
    self.codeButton.layer.borderWidth = 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBrownColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBrownColor.CGColor;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBgColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBgColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBgColor.CGColor;
    }
}


@end
