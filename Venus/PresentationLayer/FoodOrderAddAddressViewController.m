//
//  FoodOrderAddAddressViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodOrderAddAddressViewController.h"
#import "FoodAddressEditCell.h"
#import "FoodAddress.h"
#import "MBProgressHUD.h"

@interface FoodOrderAddAddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FoodAddress *foodAddress;

@end

@implementation FoodOrderAddAddressViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    if (_navigationTitle) {
        self.navigationItem.title = _navigationTitle;
    } else {
        self.navigationItem.title = @"编辑地址";
    }
//    self.saveButton.title = @"保存";
//    self.saveButton.tintColor = GMBrownColor;
}

#pragma mark -- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodAddressEditCell *cell = [FoodAddressEditCell cellForTableView:tableView];
    if (indexPath.row == 0) {
        cell.project.text = @"联系人";
        cell.content.placeholder = @"请输入联系人";
    } else if (indexPath.row == 1) {
        cell.project.text = @"收货地址";
        cell.content.placeholder = @"请输入收货地址";
    } else if (indexPath.row == 2) {
        cell.project.text = @"手机号";
        cell.content.placeholder = @"请输入手机号码";
        cell.content.keyboardType = UIKeyboardTypePhonePad;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark - private methods
- (NSString *)getContentOfCellAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FoodAddressEditCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.content.text;
}

#pragma mark - event response
- (IBAction)blankTouched:(id)sender {
    [self.view endEditing:YES];
}

- (void)saveAddress:(id)sender {
    NSLog(@"保存");
    if ([[self getContentOfCellAtIndex:0] isEqualToString:@""]|| [self getContentOfCellAtIndex:0] == nil) {
        // 弹出提示
    } else {
        self.foodAddress.linkmanName = [self getContentOfCellAtIndex:0];
    }
    
    if ([[self getContentOfCellAtIndex:1] isEqualToString:@""]|| [self getContentOfCellAtIndex:1] == nil) {
        // 弹出提示
    } else {
        self.foodAddress.address = [self getContentOfCellAtIndex:1];
    }
    
    if ([[self getContentOfCellAtIndex:2] isEqualToString:@""]|| [self getContentOfCellAtIndex:2] == nil) {
        // 弹出提示
    } else {
        self.foodAddress.phoneNumber = [self getContentOfCellAtIndex:2];
    }
}

#pragma mark - getters and setters
- (UIBarButtonItem *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(saveAddress:)];
    }
    return _saveButton;
}

- (FoodAddress *)foodAddress {
    if (!_foodAddress) {
        _foodAddress = [[FoodAddress alloc] init];
    }
    return _foodAddress;
}

@end
