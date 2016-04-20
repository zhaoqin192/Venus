//
//  LoginViewController.m
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "NetworkFetcher+User.h"
#import "SDKManager.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kOFFSET_FOR_KEYBOARD 80.0


@interface LoginViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)accountLogin:(id)sender;
- (IBAction)weixinLogin:(id)sender;
- (IBAction)weiboLogin:(id)sender;
- (IBAction)qqLogin:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)createAccount:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews{

    [self setTextFieldLineWithField:self.accountTextField color:UIColorFromRGB(0xFFFFFF) image:@"loginAccount"];
    [self setTextFieldLineWithField:self.passwordTextField color:UIColorFromRGB(0xFFFFFF) image:@"loginPassword"];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (IBAction)accountLogin:(id)sender {
    
    if ([_accountTextField.text isEqualToString:@""] || [_passwordTextField isEqual:@""]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"用户名或密码不能为空";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1.5);
        } completionBlock:^{
            //操作执行完后取消对话框
            [hud removeFromSuperview];
        }];
    }else{
        [NetworkFetcher userLoginWithAccount:_accountTextField.text password:_passwordTextField.text success:^{
            
        } failure:^(NSString *error) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = error;
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
            
        }];
    }
    
}

- (IBAction)weixinLogin:(id)sender {
    
}

- (IBAction)weiboLogin:(id)sender {
}

- (IBAction)qqLogin:(id)sender {
    
    [[SDKManager sharedInstance] authorWithQQ];
    
}

- (IBAction)forgetPassword:(id)sender {
}

- (IBAction)createAccount:(id)sender {
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [self setTextFieldLineWithField:self.accountTextField color:UIColorFromRGB(0xA6873B) image:@"loginAccountHL"];
    }else if (textField.tag == 2){
        [self setTextFieldLineWithField:self.passwordTextField color:UIColorFromRGB(0xA6873B) image:@"loginPasswordHL"];
        [self setViewMovedUp:YES];
    }
    
}

- (void) setTextFieldLineWithField:(UITextField *)textField color:(UIColor *)color image:(NSString *)image{
    CALayer *bottomBorderAccount = [CALayer layer];
    bottomBorderAccount.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width * 2, 1.0f);
    bottomBorderAccount.backgroundColor = color.CGColor;
    [textField.layer addSublayer:bottomBorderAccount];
    UIView *paddingViewAccount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [paddingViewAccount addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:image]]];
    textField.leftView = paddingViewAccount;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [self setTextFieldLineWithField:self.accountTextField color:UIColorFromRGB(0xFFFFFF) image:@"loginAccount"];
    }else if (textField.tag == 2){
        [self setTextFieldLineWithField:self.passwordTextField color:UIColorFromRGB(0xFFFFFF) image:@"loginPassword"];
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



@end
