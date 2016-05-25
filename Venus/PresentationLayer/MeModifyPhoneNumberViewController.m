//
//  MeModifyPhoneNumberViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MeModifyPhoneNumberViewController.h"

@interface MeModifyPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation MeModifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改手机号";
    self.view.backgroundColor = GMBgColor;
    [self.saveButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
    self.saveButton.backgroundColor = GMRedColor;
    [self.saveButton bk_whenTapped:^{
        NSLog(@"完成");
    }];
    
    [self.codeButton setTitleColor:GMRedColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:GMTipFontColor forState:UIControlStateDisabled];
    [self.codeButton bk_whenTapped:^{
        NSLog(@"code");
    }];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.layer.masksToBounds = YES;
    [RACObserve(self.codeButton, enabled) subscribeNext:^(NSNumber *x) {
        if ([x  isEqual: @(1)]) {
            self.codeButton.layer.borderColor = GMRedColor.CGColor;
        }
        else {
            self.codeButton.layer.borderColor = GMTipFontColor.CGColor;
        }
    }];
    RAC(self.codeButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal] reduce:^(NSString *phone){
        return @(phone.length == 11);
    }];
    RAC(self.saveButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,self.codeTF.rac_textSignal] reduce:^(NSString *phone,NSString *code){
        return @(phone.length && code.length);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}


@end
