//
//  NewFoodDetailViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "NewFoodDetailViewController.h"
#import "XFSegementView.h"
#import "NewFoodManager.h"

@interface NewFoodDetailViewController () <UITableViewDelegate, UITableViewDataSource, TouchLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *storeIconImage;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSoldCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *basePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *packFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NewFoodManager *foodManager;

@property (strong, nonatomic) XFSegementView *segementView;
@property (assign, nonatomic) NSInteger *currentVCIndex;

@end

@implementation NewFoodDetailViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

#pragma mark - UITableViewDelegate

#pragma mark - private methods

#pragma mark - event response
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)groupBuyButtonClicked:(id)sender {
    
}

- (IBAction)storeButtonClicked:(id)sender {
    
}

- (IBAction)trollyButtonClicked:(id)sender {
    
}

- (IBAction)confirmButtonClicked:(id)sender {
    
}

- (IBAction)shadowViewClicked:(id)sender {
    
}


#pragma mark - getters and setters
- (XFSegementView *)segementView {
    if (_segementView) {
        return _segementView;
    } else {
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, 40)];
        _segementView.titleArray = @[@"点菜",@"评论"];
        _segementView.titleColor = [UIColor lightGrayColor];
        _segementView.haveRightLine = YES;
        _segementView.separateColor = [UIColor grayColor];
        [_segementView.scrollLine setBackgroundColor:GMBrownColor];
        _segementView.titleSelectedColor = GMBrownColor;
        _segementView.touchDelegate = self;
        [_segementView selectLabelWithIndex:0];
        _currentVCIndex = 0;
        return _segementView;
    }
}

@end
