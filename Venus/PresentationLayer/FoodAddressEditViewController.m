//
//  FoodAddressEditViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddressEditViewController.h"
#import "FoodAddressEditCell.h"
#import "FoodAddress.h"
#import "PresentationUtility.h"
#import "NetworkFetcher+FoodAddress.h"

@interface FoodAddressEditViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FoodAddress *foodAddressCache;

@end

@implementation FoodAddressEditViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"编辑地址";
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodAddressEditCell *cell = [FoodAddressEditCell cellForTableView:tableView];
    if (indexPath.row == 0) {
        cell.project.text = @"联系人";
        cell.content.text = self.foodAddressCache.linkmanName;
    } else if (indexPath.row == 1) {
        cell.project.text = @"收货地址";
        cell.content.text = self.foodAddressCache.address;
    } else if (indexPath.row == 2) {
        cell.project.text = @"手机号";
        cell.content.text = self.foodAddressCache.phoneNumber;
        cell.content.keyboardType = UIKeyboardTypePhonePad;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark - private methods

- (NSString *)getContentOfCellAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FoodAddressEditCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.content.text;
}

- (void)clearContentOfCellAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FoodAddressEditCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.content.text = @"";
}

- (BOOL) isStringNonnull:(NSString *)string {
    if ([string isEqualToString:@""] || string == nil) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - event response

- (IBAction)blankTouched:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [NetworkFetcher deleteUserFoodAddress:self.foodAddressCache success:^{
        [self clearContentOfCellAtIndex:0];
        [self clearContentOfCellAtIndex:1];
        [self clearContentOfCellAtIndex:2];
        [PresentationUtility showTextDialog:self.view text:@"删除收货地址成功" success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString *error){
        [PresentationUtility showTextDialog:self.view text:@"删除收货地址失败,请重试" success:nil];
        NSLog(@"错误是：%@",error);
    }];
}

- (void)saveAddress:(id)sender {
    NSLog(@"保存");
    NSString *name = [self getContentOfCellAtIndex:0];
    NSString *address = [self getContentOfCellAtIndex:1];
    NSString *phoneNumber = [self getContentOfCellAtIndex:2];
    
    if ([self isStringNonnull:name] && [self isStringNonnull:address] && [self isStringNonnull:phoneNumber]) {
        self.foodAddressCache.linkmanName = [self getContentOfCellAtIndex:0];
        self.foodAddressCache.address = [self getContentOfCellAtIndex:1];
        self.foodAddressCache.phoneNumber = [self getContentOfCellAtIndex:2];
        
        [NetworkFetcher editUserFoodAddress:self.foodAddressCache success:^{
            [self clearContentOfCellAtIndex:0];
            [self clearContentOfCellAtIndex:1];
            [self clearContentOfCellAtIndex:2];
            [PresentationUtility showTextDialog:self.view text:@"保存收货地址成功" success:^{
                // 返回上级页面
                self.foodAddressToEdit.linkmanName = self.foodAddressCache.linkmanName;
                self.foodAddressToEdit.address = self.foodAddressCache.address;
                self.foodAddressToEdit.phoneNumber = self.foodAddressCache.phoneNumber;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(NSString *error){
            [PresentationUtility showTextDialog:self.view text:@"保存联系人失败,请重试" success:nil];
            NSLog(@"错误是：%@",error);
        }];
    } else {
        if (![self isStringNonnull:name]) {
            [PresentationUtility showTextDialog:self.view text:@"请输入联系人" success:nil];
        } else {
            if (![self isStringNonnull:address]) {
                [PresentationUtility showTextDialog:self.view text:@"请输入收货地址" success:nil];
            } else {
                if (![self isStringNonnull:phoneNumber]) {
                    [PresentationUtility showTextDialog:self.view text:@"请输入手机号码" success:nil];
                }
            }
        }
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

- (FoodAddress *)foodAddressToEdit {
    if (!_foodAddressToEdit) {
        _foodAddressToEdit = [[FoodAddress alloc] init];
    }
    return _foodAddressToEdit;
}

- (FoodAddress *)foodAddressCache {
    if (!_foodAddressCache) {
        _foodAddressCache = [[FoodAddress alloc] init];
        _foodAddressCache.linkmanName = _foodAddressToEdit.linkmanName;
        _foodAddressCache.address = _foodAddressToEdit.address;
        _foodAddressCache.addressID = _foodAddressToEdit.addressID;
        _foodAddressCache.phoneNumber = _foodAddressToEdit.phoneNumber;
    }
    return _foodAddressCache;
}

@end
