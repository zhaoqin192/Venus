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


@interface GMRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet GMXTextField *codeTF;
@property (weak, nonatomic) IBOutlet GMXTextField *passwordTF;
@property (weak, nonatomic) IBOutlet GMXTextField *repasswordTF;
@property (weak, nonatomic) IBOutlet GMButton *agreeButton;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSNumber *timerCount;

@end

@implementation GMRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"手机注册"]];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self selectTextForTitle];
    [self configureUI];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBrownColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBrownColor.CGColor;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSUInteger lineTag = textField.tag + 100;
    UIView *lineView = [self.view viewWithTag:lineTag];
    lineView.backgroundColor = GMBgColor;
    
    if (textField.tag == 10) {
        [self.codeButton setTitleColor:GMBgColor forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = GMBgColor.CGColor;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)fetchCode:(id)sender {
    [self enterCode];
}

- (void)enterCode{
    if ([self.phoneTF.text length] < 11) {
        [PresentationUtility showTextDialog:self.view text:@"请输入中国大陆11位手机号" success:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        self.codeButton.enabled = NO;
        [self.codeButton setAlpha:0.5f];
        _timerCount = @30;
        [NetworkFetcher userSendCodeWithNumber:self.phoneTF.text success:^{
            [PresentationUtility showTextDialog:weakSelf.view text:@"验证码已发送" success:nil];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                int value = [weakSelf.timerCount intValue];
                value--;
                weakSelf.timerCount = [NSNumber numberWithInt:value];
                NSString *string = @"已发送";
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%d", [weakSelf.timerCount intValue]]];
                [weakSelf.codeButton setTitle:string forState:UIControlStateNormal];
                if (value == 0) {
                    weakSelf.codeButton.enabled = YES;
                    [weakSelf.codeButton setAlpha:1.0f];
                    [weakSelf.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }
            } repeats:YES];
        } failure:^(NSString *error) {
            [PresentationUtility showTextDialog:self.view text:error success:nil];
            self.codeButton.enabled = YES;
            [self.codeButton setAlpha:1.0f];
        }];
    }
}

- (IBAction)closeView:(id)sender {
    self.appDelegate.state = ORDINARY;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreeAndRegister:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (![_passwordTF.text isEqualToString:_repasswordTF.text]) {
        [PresentationUtility showTextDialog:weakSelf.view text:@"密码不一致" success:nil];
    }else{
        switch (self.appDelegate.state) {
            case ORDINARY:{
                [NetworkFetcher userValidateSMS:_codeTF.text mobile:_phoneTF.text success:^(NSString *token) {
                    [NetworkFetcher userRegisterWithPhone:_phoneTF.text password:_passwordTF.text token:token success:^{
                        [PresentationUtility showTextDialog:weakSelf.view text:@"注册成功" success:^{
                            self.appDelegate.state = ORDINARY;
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    } failure:^(NSString *error) {
                        [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                    }];
                } failure:^(NSString *error) {
                    [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                }];
                break;
            }
            case WECHAT:{
                //验证手机号并绑定
                [NetworkFetcher userValidateSMS:_codeTF.text mobile:_phoneTF.text success:^(NSString *token) {
                    //向第三方请求用户信息
                    [NetworkFetcher userFetchUserInfoWithWeChatToken:self.token openID:self.openID Success:^(NSDictionary *userInfo) {

                        [NetworkFetcher userBindWeChatWithOpenID:userInfo[@"openid"] name:userInfo[@"nickname"] sex:userInfo[@"sex"] avatar:userInfo[@"headimgurl"] account:self.phoneTF.text password:self.passwordTF.text token:token success:^{
                            [PresentationUtility showTextDialog:weakSelf.view text:@"绑定成功" success:^{
                                self.appDelegate.state = ORDINARY;
                                [self dismissViewControllerAnimated:NO completion:^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTER_HOME" object:nil];
                                }];
                            }];
                        } failure:^(NSString *error) {
                            [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                        }];
                    } failure:^(NSString *error) {
                        [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                    }];
                } failure:^(NSString *error) {
                    [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];

                }];
                break;
            }
            case QQ:{

                
                [NetworkFetcher userValidateSMS:_codeTF.text mobile:_phoneTF.text success:^(NSString *token) {
                    //向QQ请求用户信息
                    [NetworkFetcher userFetchUserInfoWithQQToken:self.token openID:self.openID success:^(NSDictionary *userInfo) {
                        [NetworkFetcher userBindQQWithOpenID:self.openID name:userInfo[@"nickname"] avatar:userInfo[@"figureurl"] account:self.phoneTF.text password:self.passwordTF.text token:token success:^{
                            [PresentationUtility showTextDialog:weakSelf.view text:@"绑定成功" success:^{
                                self.appDelegate.state = ORDINARY;
                                [self dismissViewControllerAnimated:NO completion:^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTER_HOME" object:nil];
                                }];
                            }];
                        } failure:^(NSString *error) {
                            [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                        }];
                    } failure:^(NSString *error) {
                        [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                    }];
                } failure:^(NSString *error) {
                    [PresentationUtility showTextDialog:weakSelf.view text:error success:nil];
                }];
                break;
            }
            case WEIBO:{
                
            }
            default:
                break;
        }
        
        
        
    }
}

@end
