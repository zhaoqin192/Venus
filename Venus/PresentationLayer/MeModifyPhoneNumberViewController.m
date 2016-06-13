//
//  MeModifyPhoneNumberViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MeModifyPhoneNumberViewController.h"
#import "NetworkFetcher+User.h"
#import "GMLoginViewController.h"

@interface MeModifyPhoneNumberViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (nonatomic, strong) UIButton *clearButton;
@end

static NSInteger count = 30;
@implementation MeModifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改手机号";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.passwordView.hidden = YES;
    self.clearButton.hidden = YES;
    if (self.isForget) {
        self.navigationItem.title = @"修改密码";
        self.topConstraint.constant = 70;
        [self.view layoutIfNeeded];
        self.headLabel.text = @"通过手机号验证修改密码";
        self.passwordView.hidden = NO;
        self.clearButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(8, 16, 36, 36);
            [button setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
            [button bk_whenTapped:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            button;
        });
        [self.view addSubview:self.clearButton];
    }
    self.view.backgroundColor = GMBgColor;
    [self.saveButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
    self.saveButton.backgroundColor = GMRedColor;
    [self.saveButton bk_whenTapped:^{
        if (self.isForget) {
            if (![self.passTF.text isEqualToString: self.confirmTF.text]) {
                [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5
                 ];
                return ;
            }
        }
        [self confirmCode];
    }];
    
    [self.codeButton setTitleColor:GMRedColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:GMTipFontColor forState:UIControlStateDisabled];
    [self.codeButton bk_whenTapped:^{
        [self.codeTF becomeFirstResponder];
        self.phoneTF.delegate = self;
        if (self.isForget) {
            [self sendCode];
        }
        else {
            [self confirmPhone];
        }
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
    if (self.isForget) {
        RAC(self.saveButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,self.codeTF.rac_textSignal,self.passTF.rac_textSignal,self.confirmTF.rac_textSignal] reduce:^(NSString *phone,NSString *code,NSString *pass,NSString *confirm){
            return @(phone.length && code.length && pass.length && confirm.length);
        }];
    }
    else {
        RAC(self.saveButton,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,self.codeTF.rac_textSignal] reduce:^(NSString *phone,NSString *code){
            return @(phone.length && code.length);
        }];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    count = 30;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)startTimer {
    if (count == 0) {
        count = 30;
        [self.timer invalidate];
        self.codeButton.enabled = YES;
        self.phoneTF.delegate = nil;
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateDisabled];
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)count] forState:UIControlStateDisabled];
        count--;
    }
}

- (void)confirmPhone {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/check/mobile"]];
    NSDictionary *parameters = @{@"mobile": self.phoneTF.text};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
        for (NSString *key in cookieHeaders) {
            [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
        }
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        if ([responseObject[@"is_exists"] isEqual: @(1)]) {
            [SVProgressHUD showErrorWithStatus:@"该手机已注册"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [self sendCode];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)sendCode {
    self.codeButton.enabled = NO;
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/sms/sendcode"]];
    NSDictionary *parameters = @{@"mobile": self.phoneTF.text};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
        for (NSString *key in cookieHeaders) {
            [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
        }
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)modifyPhone {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/change/mobile"]];
    NSDictionary *parameters = @{@"mobile": self.phoneTF.text,@"code":self.codeTF.text};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
        for (NSString *key in cookieHeaders) {
            [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
        }
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改手机号成功,请重新登录"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        [self.navigationController popViewControllerAnimated:NO];
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)confirmCode{
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/sms/validate"]];
    NSDictionary *parameters = @{@"mobile": self.phoneTF.text, @"code": self.codeTF.text};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
//        NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
//        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieStorage];
//        for (NSString *key in cookieHeaders) {
//            [[manager requestSerializer] setValue:cookieHeaders[key] forHTTPHeaderField:key];
//        }
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        self.token = responseObject[@"token"];
        if (self.isForget) {
            [self modifyNewPassword];
        }
        else {
            [self modifyPhone];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"confirm code %@", error);
    }];
}

- (void)modifyNewPassword {
    NSLog(@"jjj");
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/reset/password/mobile"]];
    NSDictionary *parameters = @{@"password":self.passTF.text,
                                 @"token":self.token};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
        [self dismissViewControllerAnimated:YES completion:nil];
       // [self.navigationController popViewControllerAnimated:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


@end
