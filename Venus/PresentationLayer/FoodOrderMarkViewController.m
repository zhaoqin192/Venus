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

@implementation FoodOrderMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.title = @"添加备注";
}

#pragma mark - event response
- (void)confirmButtonClicked:(id)sender {
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

@end
