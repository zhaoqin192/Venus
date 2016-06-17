//
//  BindViewController.m
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BindViewController.h"
#import "BindViewModel.h"
#import "Appdelegate.h"
#import "MBProgressHUD.h"
#import "GMRegisterViewController.h"

@interface BindViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *accountInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) BindViewModel *viewModel;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self configureUI];
    [self bindViewModel];
    
}

- (void)configureUI {
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    self.avatarImage.layer.masksToBounds = YES;
    UIColor *color = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
}

- (void)bindViewModel {
    
    self.viewModel = [[BindViewModel alloc] init];
    RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.commitButton, enabled) = [self.viewModel buttonIsValid];
    
    @weakify(self)
    [[RACSignal merge:@[self.viewModel.bindCommand.errors, self.viewModel.infoCommand.errors]]
    subscribeNext:^(id x) {
        @strongify(self)
        if (!self.commitButton.isEnabled) {
            self.commitButton.enabled = YES;
        }
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"网络异常";
        [self.hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    doNext:^(id x) {
        @strongify(self)
        self.commitButton.enabled = NO;
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"正在登录……";
    }]
    flattenMap:^RACStream *(id value) {
        @strongify(self)
        return [self.viewModel.bindCommand execute:nil];
    }]
    subscribeNext:^(NSNumber *signedIn) {
        @strongify(self)
        self.commitButton.enabled = YES;
        if ([signedIn isEqualToNumber:@0]) {
            self.hud.labelText = @"绑定成功";
            self.hud.mode = MBProgressHUDModeText;
            [self.hud showAnimated:YES whileExecutingBlock:^{
                //对话框显示时需要执行的操作
                sleep(1.5);
            } completionBlock:^{
                [self.hud removeFromSuperview];
                UIViewController *vc = self.presentingViewController;
                while (vc.presentingViewController) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:YES completion:NULL];
            }];
        }
        else {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"用户名或密码错误";
            [self.hud hide:YES afterDelay:1.5f];
        }
    }];
    
    
    [[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        GMRegisterViewController *vc = [[GMRegisterViewController alloc] init];
        vc.token = _token;
        vc.openID = _openID;
        [self presentViewController:vc animated:NO completion:nil];
    }];
    
    NSDictionary *info = @{@"token": _token, @"openID": _openID};
    [[self.viewModel.infoCommand execute:info]
    subscribeNext:^(id x) {
        if (_appDelegate.state == QQ) {
            @strongify(self)
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
            self.accountInfoLabel.text = [NSString stringWithFormat:@"您已登陆QQ账号：%@", self.viewModel.accountName];
            self.tipLabel.text = @"绑定后，您的QQ账户和国贸账号都可登录";
        }
        else if (_appDelegate.state == WECHAT) {
            @strongify(self)
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
            self.accountInfoLabel.text = [NSString stringWithFormat:@"您已登陆微信账号：%@", self.viewModel.accountName];
            self.tipLabel.text = @"绑定后，您的微信账户和国贸账号都可登录";
        }
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
