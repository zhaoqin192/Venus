//
//  MeModifyPhoneNumberViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MeModifyPhoneNumberViewController.h"
#import "NetworkFetcher+User.h"

@interface MeModifyPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@end

static NSInteger count = 30;
@implementation MeModifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改手机号";
    self.view.backgroundColor = GMBgColor;
    [self.saveButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
    self.saveButton.backgroundColor = GMRedColor;
    [self.saveButton bk_whenTapped:^{
        [self modifyPhone];
    }];
    
    [self.codeButton setTitleColor:GMRedColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:GMTipFontColor forState:UIControlStateDisabled];
    [self.codeButton bk_whenTapped:^{
        [self.codeTF becomeFirstResponder];
        [self sendCode];
        self.codeButton.enabled = NO;
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
        [self.codeButton setTitle:@"再次发送" forState:UIControlStateDisabled];
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)count] forState:UIControlStateDisabled];
        count--;
    }
}

- (void)sendCode {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/sms/sendcode"]];
    NSDictionary *parameters = @{@"mobile": self.phoneTF.text};
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改手机号成功"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


@end
