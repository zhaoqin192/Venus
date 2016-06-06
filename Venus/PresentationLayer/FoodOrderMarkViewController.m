//
//  FoodOrderMarkViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderMarkViewController.h"

@interface FoodOrderMarkViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *currentCommentCount;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (copy ,nonatomic) NSString *remark;

@end

static NSInteger const textLimit = 50;

@implementation FoodOrderMarkViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.title = @"添加备注";
    if (![self.markContent isEqualToString:@""]) {
        self.textField.text = self.markContent;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}

#pragma mark - TextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    changeContent = [[NSMutableArray alloc] init];
//    //    if (textField.tag == numberOfTextFields - 1) {
//    for (int i = 0; i < textFields.count; i++) {
//        UITextField* textField = textFields[i];
//        changeContent[i] = textField.text;
//    }
//    [self.delegate textFieldViewController:self DidFinishEditingContent:changeContent];
//    //        [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:0.2f];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:textField];
//    [self dismissViewControllerAnimated:true completion:nil];
//    //    }
//    return YES;
//}




#pragma mark - private methods
-(void)textFiledEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= textLimit) {
                textField.text = [toBeString substringToIndex:textLimit];
            } else {
                [textField setText:toBeString];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            NSLog(@"输入的英文还没有转化为汉字的状态");
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > textLimit) {
            textField.text = [toBeString substringToIndex:textLimit];
        }
    }
    self.currentCommentCount.text = [NSString stringWithFormat:@"%li",(long)textField.text.length];
}

#pragma mark - event response
- (void)confirmButtonClicked:(id)sender {
    self.remark = self.textField.text;
    if (self.delegate) {
        [self.delegate didGetRemark:self.remark];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters
- (UIBarButtonItem *)rightBarButtonItem {
    NSLog(@"lalala");
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
    }
    return _rightBarButtonItem;
}

- (NSString *)remark {
    if (!_remark) {
        _remark = @"";
    }
    return _remark;
}

- (NSString *)markContent {
    if (!_markContent) {
        _markContent = @"";
    }
    return _markContent;
}

@end
