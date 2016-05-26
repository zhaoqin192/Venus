//
//  MeModifyPasswordViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MeModifyPasswordViewController.h"
#import "GMLoginViewController.h"

@interface MeModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;

@end

@implementation MeModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = GMBgColor;
    [self.saveButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
    self.saveButton.backgroundColor = GMRedColor;
    [self.saveButton bk_whenTapped:^{
        if (![self.passwordTF.text isEqualToString: self.confirmTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5
             ];
            return ;
        }
        [self confirmOldPassword];
    }];

    RAC(self.saveButton,enabled) = [RACSignal combineLatest:@[self.oldPasswordTF.rac_textSignal,self.passwordTF.rac_textSignal,self.confirmTF.rac_textSignal] reduce:^(NSString *old,NSString *password,NSString *confirm){
        return @(old.length && password.length && confirm.length);
    }];
}

- (void)confirmOldPassword {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/check/password"]];
    NSDictionary *parameters = @{@"oldpwd":self.oldPasswordTF.text};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [self modifyNewPassword];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

- (void)modifyNewPassword {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/change/password"]];
    NSDictionary *parameters = @{@"newpwd":self.passwordTF.text};
    [manager POST:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success %@",responseObject);
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改密码成功,请重新登录"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
        [self.navigationController popViewControllerAnimated:NO];
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
