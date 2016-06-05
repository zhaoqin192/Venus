//
//  GMMeTakeAwayRatingViewController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayRatingViewController.h"
#import "GMMeTakeAwayRatingCell.h"
#import "GMMeTakeAwayRatingStarCell.h"
#import "GMMeTakeAwayRefundReasonCell.h"
#import "NetworkFetcher+FoodOrder.h"
#import "PresentationUtility.h"

@interface GMMeTakeAwayRatingViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;

@property (copy, nonatomic) NSString *commentContent;
@property (assign, nonatomic) NSInteger ratingGrade;

@property (assign, nonatomic) NSInteger costTime;

@property (strong, nonatomic) NSArray *timeArray;
@property (copy, nonatomic) NSString *chosenTime;
@property (assign, nonatomic) NSInteger chosenIndex;

@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;


@end

@implementation GMMeTakeAwayRatingViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    _costTime = 40;
    _ratingGrade = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    self.storeName.text = self.name;
    [self.storeIcon sd_setImageWithURL:[NSURL URLWithString:self.storeIconURL]];
    self.navigationItem.title = @"评价";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GMMeTakeAwayRatingCell *cell = [GMMeTakeAwayRatingCell cellForTableView:tableView];
            cell.content1.text = @"送餐速度";
            cell.content2.text = [NSString stringWithFormat:@"%li分钟",(long)_costTime];
            return cell;
        } else {
            GMMeTakeAwayRatingStarCell *cell = [GMMeTakeAwayRatingStarCell cellForTableView:tableView];
            [cell.starRatingView addTarget:self action:@selector(ratingStarTouched:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
    }  else {
        GMMeTakeAwayRefundReasonCell *cell = [GMMeTakeAwayRefundReasonCell cellForTableView:tableView];
        cell.textField.placeholder = @"请在此输入您的宝贵意见";
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 100.0;
    } else {
        return 56.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.shadowView.hidden = NO;
            self.pickerContainerView.hidden = NO;
        }
    }
    [self.view endEditing:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.timeArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.timeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.chosenTime = [NSString stringWithFormat:@"%@",[self.timeArray objectAtIndex:row]];
    self.chosenIndex = row;
}

#pragma mark - private methods

#pragma mark - event response
- (IBAction)submitButtonClicked:(id)sender {
    NSLog(@"提交评论");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    GMMeTakeAwayRefundReasonCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.commentContent = cell.textField.text;
    [NetworkFetcher foodUserCreateCommentWithOrderId:self.orderID deliveryTime:self.deliveryTime foodGrade:self.ratingGrade content:self.commentContent storeId:self.storeID pictures:@[] success:^(NSDictionary *response) {
        NSLog(@"评论成功了!");
        [PresentationUtility showTextDialog:self.view text:@"评论成功" success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString *error) {
    
    }];
}

- (void)ratingStarTouched:(id)sender {
    HCSStarRatingView *ratingView = (HCSStarRatingView *)sender;
    self.ratingGrade = ratingView.value;
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.pickerContainerView.hidden = YES;
    self.shadowView.hidden = YES;
}

- (IBAction)confirmButtonClicked:(id)sender {
    self.pickerContainerView.hidden = YES;
    self.shadowView.hidden = YES;
    switch (self.chosenIndex) {
        case 0:
            self.costTime = 10;
            break;
        case 1:
            self.costTime = 20;
            break;
        case 2:
            self.costTime = 30;
            break;
        case 3:
            self.costTime = 40;
            break;
        case 4:
            self.costTime = 50;
            break;
        case 5:
            self.costTime = 60;
            break;
        case 6:
            self.costTime = 70;
            break;
        case 7:
            self.costTime = 80;
            break;
        case 8:
            self.costTime = 90;
            break;
        case 9:
            self.costTime = 100;
            break;
        case 10:
            self.costTime = 110;
            break;
        case 11:
            self.costTime = 120;
            break;
        case 12:
            self.costTime = 130;
            break;
        default:
            break;
    }

}

#pragma mark - getters and setters
- (NSString *)commentContent {
    if (!_commentContent) {
        _commentContent = @"";
    }
    return _commentContent;
}

- (NSArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [[NSArray alloc] initWithObjects:@"10分钟",@"20分钟",@"30分钟",@"40分钟",@"50分钟",@"1小时",@"1小时10分钟",@"1小时20分钟",@"1小时30分钟",@"1小时40分钟",@"1小时40分钟",@"2小时",@"2小时以上", nil];
    }
    return _timeArray;
}

- (void)setCostTime:(NSInteger)costTime {
    _costTime = costTime;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GMMeTakeAwayRatingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (costTime < 60) {
            cell.content2.text = [NSString stringWithFormat:@"%li分钟",(long)costTime];
        } else if (costTime < 120) {
            cell.content2.text = [NSString stringWithFormat:@"1小时%li分钟",(long)costTime - 60];
        } else if (costTime == 120) {
            cell.content2.text = [NSString stringWithFormat:@"2小时"];
        } else {
            cell.content2.text = [NSString stringWithFormat:@"2小时以上"];
        }
    }
}

@end
