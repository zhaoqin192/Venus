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

@interface BindViewController ()
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
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self configureUI];
    [self bindViewModel];
    
    if (_appDelegate.state == QQ) {
        [_viewModel fetchQQInfoWithToken:_token openID:_openID];
    }
    else if (_appDelegate.state == WECHAT) {
        [_viewModel fetcheWechatInfoWithToken:_token openID:_openID];
    }
    
}

- (void)configureUI {
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    self.avatarImage.layer.masksToBounds = YES;
    UIColor *color = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)bindViewModel {
    
    self.viewModel = [[BindViewModel alloc] init];
    RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.commitButton, enabled) = [self.viewModel buttonIsValid];
    
    @weakify(self)
    [self.viewModel.bindSuccessObject subscribeNext:^(id x) {
        @strongify(self);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"绑定成功";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1.5);
        } completionBlock:^{
            [hud removeFromSuperview];
            UIViewController *vc = self.presentingViewController;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:NULL];
        }];
    }];
    
    [self.viewModel.bindFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.infoSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
        if (_appDelegate.state == QQ) {
            self.accountInfoLabel.text = [NSString stringWithFormat:@"您已登陆QQ账号：%@", self.viewModel.accountName];
            self.tipLabel.text = @"绑定后，您的QQ账户和国贸账号都可登录";
        }
        else if (_appDelegate.state == WECHAT) {
            self.accountInfoLabel.text = [NSString stringWithFormat:@"您已登陆微信账号：%@", self.viewModel.accountName];
            self.tipLabel.text = @"绑定后，您的微信账户和国贸账号都可登录";
        }
        
    }];
    
    [self.viewModel.infoFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (_appDelegate.state == QQ) {
            [self.viewModel bindQQ];
        }
        else if (_appDelegate.state == WECHAT) {
            [self.viewModel bindWechat];
        }
    }];
    
    [[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        GMRegisterViewController *vc = [[GMRegisterViewController alloc] init];
        vc.token = self.token;
        vc.openID = self.openID;
        [self presentViewController:vc animated:NO completion:nil];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
