//
//  GMRegisterViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMRegisterViewController.h"
#import "NetworkFetcher+User.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GMXTextField.h"
#import "PresentationUtility.h"
#import "SignUpViewModel.h"


@interface GMRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet GMXTextField *codeTF;
@property (weak, nonatomic) IBOutlet GMXTextField *passwordTF;
@property (weak, nonatomic) IBOutlet GMXTextField *repasswordTF;
@property (weak, nonatomic) IBOutlet GMButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSNumber *timerCount;
@property (nonatomic, strong) SignUpViewModel *viewModel;

@end

@implementation GMRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"手机注册"]];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self selectTextForTitle];
    [self configureUI];
    
    [self bindViewModel];
    [self onClick];
}

- (void)bindViewModel {
    _viewModel = [[SignUpViewModel alloc] init];
    RAC(self.viewModel, phone) = self.phoneTF.rac_textSignal;
    RAC(self.viewModel, authCode) = self.codeTF.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
    RAC(self.viewModel, rePassword) = self.repasswordTF.rac_textSignal;
    RAC(self.codeButton, enabled) = [self.viewModel authIsValid];
    RAC(self.codeButton, alpha) = [self.viewModel authAlpha];
    RAC(self.agreeButton, enabled) = [self.viewModel signUpIsValid];
    
    @weakify(self);
    [self.viewModel.authSuccessSubject subscribeNext:^(id x) {
        @strongify(self);
        [PresentationUtility showTextDialog:self.view text:@"验证码已发送" success:nil];
        
        _timerCount = @30;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            int value = [self.timerCount intValue];
            value--;
            self.timerCount = [NSNumber numberWithInt:value];
            NSString *string = [NSString stringWithFormat:@"已发送%d", [self.timerCount intValue]];
            [self.codeButton setTitle:string forState:UIControlStateNormal];
            if (value == 0) {
                self.codeButton.enabled = YES;
                [self.codeButton setAlpha:1.0f];
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.timer invalidate];
                self.timer = nil;
            }
        } repeats:YES];
    }];
    
    [self.viewModel.authFailureSubject subscribeNext:^(NSString *message) {
        @strongify(self);
        [PresentationUtility showTextDialog:self.view text:message success:nil];
    }];
    
    [self.viewModel.signUpSuccessSubject subscribeNext:^(NSString *message) {
        [PresentationUtility showTextDialog:self.view text:message success:nil];
        self.appDelegate.state = ORDINARY;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [self.viewModel.signUpFailureSubject subscribeNext:^(NSString *failure) {
        [PresentationUtility showTextDialog:self.view text:failure success:nil];
    }];
    
    [self.viewModel.errorSubject subscribeNext:^(NSString *errCode) {
        [PresentationUtility showTextDialog:self.view text:errCode success:nil];
    }];
    
    [self.viewModel.smsSuccessSubject subscribeNext:^(id x) {
        switch (self.appDelegate.state) {
            case ORDINARY:
                [self.viewModel originalSignUp];
                break;
            case WECHAT:
                [self.viewModel wechatSignUpWithToken:self.token openID:self.openID];
                break;
            case QQ:
                [self.viewModel qqSignUpWithToken:self.token openID:self.openID];
                break;
            case WEIBO:
            default:
                break;
        }
    }];
    
}

- (void)onClick {
    @weakify(self);
    [[self.codeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         self.codeButton.enabled = NO;
         [self.codeButton setAlpha:0.5f];
         [self.viewModel auth];
     }];
    
    [[self.agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (![_passwordTF.text isEqualToString:_repasswordTF.text]) {
             [PresentationUtility showTextDialog:self.view text:@"两次密码不一致" success:nil];
         } else {
             [self.viewModel smsAuth];
         }
     }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         self.appDelegate.state = ORDINARY;
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)selectTextForTitle{
    switch (self.appDelegate.state) {
        case WECHAT:
            [self.agreeButton setTitle:@"注册并与微信绑定" forState:UIControlStateNormal];
            break;
        case QQ:
            [self.agreeButton setTitle:@"注册并与QQ绑定" forState:UIControlStateNormal];
            break;
        case WEIBO:
            [self.agreeButton setTitle:@"注册并与微博绑定" forState:UIControlStateNormal];
            break;
        case ORDINARY:
            [self.agreeButton setTitle:@"注册" forState:UIControlStateNormal];
        default:
            break;
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBrownColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBrownColor.CGColor;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBgColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBgColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBgColor.CGColor;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
