//
//  GMMeInformationViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/23.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeInformationViewController.h"
#import "userIconCell.h"
#import "WXInformationDetailViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+Helper.h"
#import "NSDate+Common.h"

@interface GMMeInformationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation GMMeInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的首页";
    [self configureTableView];
    [self loadData];
}

- (void)configureTableView {
    [self.myTableView registerNib:[UINib nibWithNibName:@"userIconCell" bundle:nil] forCellReuseIdentifier:@"userIconCell"];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"informationCell"];
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/info"]];
    NSDictionary *parameters = nil;
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                userIconCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"userIconCell"];
                return cell;
                break;
            }
            case 1:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.detailTextLabel setTextColor:GMFontColor];
                cell.textLabel.text = @"用户名";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"未填写";
                return cell;
                break;
            }
            case 2:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.detailTextLabel setTextColor:GMFontColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"真实姓名";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"未填写";
                return cell;
                break;
            }
            case 3:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.detailTextLabel setTextColor:GMFontColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"性别";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"未填写";
                return cell;
                break;
            }
            case 4:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                [cell.detailTextLabel setTextColor:GMFontColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"生日";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"未填写";
                return cell;
                break;
            }
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"informationCell"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    [cell.detailTextLabel setTextColor:GMFontColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"生日";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"未填写";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    view.backgroundColor = self.myTableView.backgroundColor;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = GMFontColor;
    label.frame = CGRectMake(15, 7, kScreenWidth, 12);
    [view addSubview:label];
    label.text = @"个人资料";
    if(section == 1) {
        label.text = @"安全设置";
    }
    if(section == 2) {
        label.text = @"社交账号绑定";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;//设置可编辑
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                }];
                
                UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:deleteAction];
                [alertController addAction:archiveAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                break;
            }
            case 1:{
                WXInformationDetailViewController *vc = [[WXInformationDetailViewController alloc] init];
                vc.myTitle = @"修改用户名";
//                if (self.viewModel.nickname != nil) {
//                    vc.originContent = self.viewModel.nickname;
//                } else {
//                    vc.originContent = @"";
//                }
//                vc.delegateSignal = [RACSubject subject];
//                @weakify(self)
//                [vc.delegateSignal subscribeNext:^(NSString *message) {
//                    @strongify(self)
//                    self.viewModel.nickname = message;
//                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
//                }];
                [self.navigationController pushViewController:vc animated:YES];
               // self.state = @2;
                break;
            }
            case 2:{
                WXInformationDetailViewController *vc = [[WXInformationDetailViewController alloc] init];
                vc.myTitle = @"修改真实姓名";
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:{
                [ActionSheetStringPicker showPickerWithTitle:@"请选择性别" rows:@[@[@"男", @"女", @"未知"]] initialSelection:@[@(0)] doneBlock:^(ActionSheetStringPicker *picker, NSArray * selectedIndex, NSArray *selectedValue) {
                    NSLog(@"%@",[selectedValue firstObject]);
                } cancelBlock:nil origin:self.view];
                break;
            }
            case 4:{
                NSDate *curDate = [NSDate dateFromString:@"1990-01-01" withFormat:@"yyyy-MM-dd"];            ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                    NSString *date = [selectedDate string_yyyy_MM_dd];
                    NSLog(@"%@",date);
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    
                } origin:self.view];
                picker.minimumDate = [[NSDate date] offsetYear:-120];
                picker.maximumDate = [NSDate date];
                [picker showActionSheetPicker];
                break;
            }
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    //Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
    }
    @weakify(self)
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
//        self.viewModel.avatarImage = imageToUse;
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
