//
//  FoodOrderMarkViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderMarkViewController.h"
#import "PureLayout.h"
#import "PlaceHolderTextView.h"

@interface FoodOrderMarkViewController ()

@property (strong, nonatomic) PlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *theView;


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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification" object:self.textView];
    [self.theView addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.markContent isEqualToString:@""]) {
        self.textView.text = self.markContent;
        self.currentCommentCount.text = [NSString stringWithFormat:@"%li",(long)self.markContent.length];
    }
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChangeNotification" object:self.textView];
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

- (void)textViewEditChanged:(NSNotification *)obj {
    PlaceHolderTextView *textView = (PlaceHolderTextView *)obj.object;
    
    NSString *toBeString = textView.text;
    
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];       //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= textLimit) {
                textView.text = [toBeString substringToIndex:textLimit];
            } else {
                [textView setText:toBeString];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            NSLog(@"输入的英文还没有转化为汉字的状态");
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > textLimit) {
            textView.text = [toBeString substringToIndex:textLimit];
        }
    }
    self.currentCommentCount.text = [NSString stringWithFormat:@"%li",(long)textView.text.length];
}


#pragma mark - event response
- (void)confirmButtonClicked:(id)sender {
    self.remark = self.textView.text;
    if (self.delegate) {
        [self.delegate didGetRemark:self.remark];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters
- (UIBarButtonItem *)rightBarButtonItem {
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

- (PlaceHolderTextView *)textView {
    if (!_textView) {
        _textView = [[PlaceHolderTextView alloc] init];
        _textView.placeholder = @"在此处给商家留言";
    }
    return _textView;
}

@end
