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

- (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark - event response

- (IBAction)blankTouched:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [NetworkFetcher deleteUserFoodAddress:self.foodAddressCache success:^{
//        [self clearContentOfCellAtIndex:0];
//        [self clearContentOfCellAtIndex:1];
//        [self clearContentOfCellAtIndex:2];
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
    
    if ([self isStringNonnull:name] && [self isStringNonnull:address] && [self isStringNonnull:phoneNumber] && [self valiMobile:phoneNumber]) {
        self.foodAddressCache.linkmanName = [self getContentOfCellAtIndex:0];
        self.foodAddressCache.address = [self getContentOfCellAtIndex:1];
        self.foodAddressCache.phoneNumber = [self getContentOfCellAtIndex:2];
        
        [NetworkFetcher editUserFoodAddress:self.foodAddressCache success:^{
//            [self clearContentOfCellAtIndex:0];
//            [self clearContentOfCellAtIndex:1];
//            [self clearContentOfCellAtIndex:2];
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
                } else if (![self valiMobile:phoneNumber]) {
                    [PresentationUtility showTextDialog:self.view text:@"请输入正确的手机号码" success:nil];
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
