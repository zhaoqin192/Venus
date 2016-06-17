//
//  GMLoginViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMLoginViewController.h"
#import "GMRegisterViewController.h"
#import "GMTextField.h"
#import "MBProgressHUD.H"
#import "LoginViewModel.h"
#import "MeModifyPhoneNumberViewController.h"
#import "BindViewController.h"

@interface GMLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (nonatomic, strong) LoginViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation GMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CREATE_ACCOUNT" object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self);         
         BindViewController *bindVC = [[BindViewController alloc] init];
         NSDictionary *userInfo = notification.userInfo;
         bindVC.token = userInfo[@"token"];
         bindVC.openID = userInfo[@"openID"];
         [self presentViewController:bindVC animated:NO completion:nil];
         
     }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ENTER_HOME" object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self);
         [self dismissViewControllerAnimated:NO completion:nil];
     }];
    
    [self bindViewModel];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)bindViewModel {
    _viewModel = [[LoginViewModel alloc] init];
    RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.loginButton, enabled) = [self.viewModel buttonIsValid];
    
    @weakify(self)
    [[self.weiboButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.labelText = @"暂未开放此功能";
         hud.mode = MBProgressHUDModeText;
         [hud showAnimated:YES whileExecutingBlock:^{
             //对话框显示时需要执行的操作
             sleep(1.5);
         } completionBlock:^{
             [hud removeFromSuperview];
         }];
         
     }];
    
    [[self.createAccountButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         GMRegisterViewController *vc = [[GMRegisterViewController alloc] init];
         [self presentViewController:vc animated:YES completion:nil];
     }];
    
    [self.forgetPasswordButton bk_whenTapped:^{
        MeModifyPhoneNumberViewController *vc = [[MeModifyPhoneNumberViewController alloc] init];
        vc.isForget = YES;
        @strongify(self)
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    [[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self dismissViewControllerAnimated:YES completion:nil];
     }];

    [[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    doNext:^(id x) {
        @strongify(self)
        self.loginButton.enabled = NO;
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"正在登录……";
    }]
    flattenMap:^RACStream *(id value) {
        @strongify(self)
        return [self.viewModel.loginCommand execute:nil];
    }]
    subscribeNext:^(NSNumber *signedIn) {
        @strongify(self)
        self.loginButton.enabled = YES;
        if ([signedIn isEqualToNumber:@0]) {
            [self.hud hide:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"用户名或密码错误";
            [self.hud hide:YES afterDelay:1.5f];
        }
    }];
    
    [[self.weChatButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.viewModel loginWithWeChat];
     }];
    
    [[self.qqButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.viewModel loginWithQQ];
     }];
    
    [[RACSignal merge:@[self.viewModel.loginCommand.errors]]
    subscribeNext:^(id x) {
        if (!self.loginButton.isEnabled) {
            self.loginButton.enabled = YES;
        }
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _phoneTextField) {
        self.phoneImage.image = [UIImage imageNamed:@"loginAccountHL"];
        self.phoneView.backgroundColor = GMBrownColor;
    }
    else if (textField == _passwordTextField) {
        self.passwordImage.image = [UIImage imageNamed:@"loginPasswordHL"];
        self.passwordView.backgroundColor = GMBrownColor;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _phoneTextField) {
        self.phoneImage.image = [UIImage imageNamed:@"loginAccount"];
        self.phoneView.backgroundColor = [UIColor whiteColor];
    }
    else if (textField == _passwordTextField) {
        self.passwordImage.image = [UIImage imageNamed:@"loginPassword"];
        self.passwordView.backgroundColor = [UIColor whiteColor];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
