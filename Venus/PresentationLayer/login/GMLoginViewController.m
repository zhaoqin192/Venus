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
@property (weak, nonatomic) IBOutlet UIView *loginDataView;

@property (weak, nonatomic) IBOutlet GMButton *loginButton;
@property (weak, nonatomic) IBOutlet GMButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (nonatomic, strong) WXTextField *passwordView;
@property (nonatomic, strong) WXTextField *phoneView;
@property (nonatomic, strong) LoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet GMButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation GMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextField];
    
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
    RAC(self.viewModel, userName) = self.phoneView.textField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordView.textField.rac_textSignal;
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
        self.loginButton.enabled = NO;
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"正在登录……";
    }]
    flattenMap:^RACStream *(id value) {
        return [self.viewModel.loginCommand execute:nil];
    }]
    subscribeNext:^(NSNumber *signedIn) {
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


- (void)configureTextField{
    _passwordView = [WXTextField fetchTextView];
    _passwordView.frame = CGRectMake(0, 50, 250, 40);
    _passwordView.imageName = @"lock";
    _passwordView.selectImageName = @"lock选中";
    _passwordView.placeHoleder = @"密码";
    [_passwordView.textField setSecureTextEntry:YES];
    [_passwordView.textField setReturnKeyType:UIReturnKeyDone];
    _passwordView.textField.delegate = self;
    _passwordView.autoresizingMask = UIViewAutoresizingNone;
    [self.loginDataView addSubview:_passwordView];
    
    _phoneView = [WXTextField fetchTextView];
    _phoneView.frame = CGRectMake(0, 0, 250, 40);
    _phoneView.imageName = @"phone";
    _phoneView.selectImageName = @"phone选中";
    _phoneView.placeHoleder = @"手机号";
    [_phoneView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneView.textField setReturnKeyType:UIReturnKeyDone];
    _phoneView.textField.delegate = self;
    _phoneView.autoresizingMask = UIViewAutoresizingNone;
    [self.loginDataView addSubview:_phoneView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
