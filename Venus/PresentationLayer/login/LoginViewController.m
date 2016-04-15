//
//  LoginViewController.m
//  Venus
//
//  Created by zhaoqin on 4/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "LoginViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


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
}

- (IBAction)weixinLogin:(id)sender {
}

- (IBAction)weiboLogin:(id)sender {
}

- (IBAction)qqLogin:(id)sender {
}

- (IBAction)forgetPassword:(id)sender {
}

- (IBAction)createAccount:(id)sender {
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        [self setTextFieldLineWithField:self.accountTextField color:UIColorFromRGB(0xA6873B) image:@"loginAccountHL"];
    }else if (textField.tag == 2){
        [self setTextFieldLineWithField:self.passwordTextField color:UIColorFromRGB(0xA6873B) image:@"loginPasswordHL"];
    }
    return YES;
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
    }
}




@end
