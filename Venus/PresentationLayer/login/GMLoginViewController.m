//
//  GMLoginViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMLoginViewController.h"

@interface GMLoginViewController ()
@property (weak, nonatomic) IBOutlet GMButton *loginButton;
@end

@implementation GMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"登录bg"]];
    [self configureTextField];
}

- (void)configureTextField{
    WXTextField *passwordView = [WXTextField fetchTextField];
    passwordView.frame = CGRectMake((kScreenWidth - 250)/2, self.loginButton.frame.origin.y - 70, 250, 40);
    passwordView.imageName = @"lock";
    passwordView.selectImageName = @"lock选中";
    passwordView.placeHoleder = @"密码";
    [self.view addSubview:passwordView];
    
    WXTextField *phoneView = [WXTextField fetchTextField];
    phoneView.frame = CGRectMake((kScreenWidth - 250)/2, self.loginButton.frame.origin.y - 70 - 50, 250, 40);
    phoneView.imageName = @"phone";
    phoneView.selectImageName = @"phone选中";
    phoneView.placeHoleder = @"手机号";
    [self.view addSubview:phoneView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
