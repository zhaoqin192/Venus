//
//  GMLoginViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMLoginViewController.h"
#import "GMRegisterViewController.h"
#import "AppDelegate.h"
#import "NetworkFetcher+User.h"
#import "PresentationUtility.h"
#import "GMTextField.h"
#import "SDKManager.h"

@interface GMLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GMButton *loginButton;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) WXTextField *passwordView;
@property (nonatomic, strong) WXTextField *phoneView;

@end

@implementation GMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"登录bg"]];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self configureTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelector:) name:@"CREATE_ACCOUNT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelector:) name:@"ENTER_HOME" object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)configureTextField{
    _passwordView = [WXTextField fetchTextView];
    _passwordView.frame = CGRectMake((kScreenWidth - 250)/2, self.loginButton.frame.origin.y - 70, 250, 40);
    _passwordView.imageName = @"lock";
    _passwordView.selectImageName = @"lock选中";
    _passwordView.placeHoleder = @"密码";
    [_passwordView.textField setSecureTextEntry:YES];
    [_passwordView.textField setReturnKeyType:UIReturnKeyDone];
    _passwordView.textField.delegate = self;
    [self.view addSubview:_passwordView];
    
    _phoneView = [WXTextField fetchTextView];
    _phoneView.frame = CGRectMake((kScreenWidth - 250)/2, self.loginButton.frame.origin.y - 70 - 50, 250, 40);
    _phoneView.imageName = @"phone";
    _phoneView.selectImageName = @"phone选中";
    _phoneView.placeHoleder = @"手机号";
    [_phoneView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneView.textField setReturnKeyType:UIReturnKeyDone];
    _phoneView.textField.delegate = self;
    [self.view addSubview:_phoneView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)createAccount:(id)sender {
    GMRegisterViewController *vc = [[GMRegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)loginWithWeChat:(id)sender {
    self.appDelegate.state = WECHAT;
    [[SDKManager sharedInstance] sendAuthRequestWithWeChat];
}

- (IBAction)loginWithQQ:(id)sender {
    self.appDelegate.state = QQ;
    [[SDKManager sharedInstance] sendAuthRequestWithQQ];
}

- (void)notificationSelector:(NSNotification *)notification{
    if ([[notification name] isEqualToString:@"CREATE_ACCOUNT"]) {
        //进入注册页面，注册账号并绑定
        GMRegisterViewController *vc = [[GMRegisterViewController alloc] init];
        NSDictionary *userInfo = [notification userInfo];
        vc.token = userInfo[@"token"];
        vc.openID = userInfo[@"openID"];
        [self presentViewController:vc animated:NO completion:nil];
    }else if([[notification name] isEqualToString:@"ENTER_HOME"]){
        [self dismissViewControllerAnimated:NO completion:nil];

    }
}

- (IBAction)loginWithAccount:(id)sender {
    __weak typeof(self) weakSelf = self;
    [NetworkFetcher userLoginWithAccount:_phoneView.textField.text password:_passwordView.textField.text success:^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    } failure:^(NSString *error) {
        [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
    }];
}

@end
