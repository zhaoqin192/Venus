//
//  WXInformationDetailViewController.m
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "WXInformationDetailViewController.h"

@interface WXInformationDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WXInformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.myTitle;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:GMBrownColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (self.returnString) {
            self.returnString(self.textField.text);
        }
        [self.delegateSignal sendNext:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.textField becomeFirstResponder];
    self.textField.delegate = self;
    self.textField.text = self.originContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // Dismiss the keyboard.
    // Execute any additional code
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
