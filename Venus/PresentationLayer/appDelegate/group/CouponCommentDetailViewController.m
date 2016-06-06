//
//  CouponCommentDetailViewController.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentDetailViewController.h"
#import "CouponCommentDetailViewModel.h"
#import "CouponOrderModel.h"
#import "MBProgressHUD.h"
#import "CouponCommentDetailHeadCell.h"
#import "CouponCommentMessageCell.h"
#import "CouponCommentMessageSectionCell.h"
#import "ShowImageViewController.h"

@interface CouponCommentDetailViewController ()<UITabBarDelegate, UITableViewDataSource,UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) CouponCommentDetailViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *sendingHUD;

@end

@implementation CouponCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提交评论";
    
    [self bindViewModel];
    
    [self configureTableView];
    
    [self onClickEvent];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)bindViewModel {
    
    self.viewModel = [[CouponCommentDetailViewModel alloc] init];
    @weakify(self)
    [self.viewModel.commentSuccessObject subscribeNext:^(NSString *message) {
        
        @strongify(self)
        
        if (!self.sendingHUD.isHidden) {
            [self.sendingHUD hide:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
        hud.completionBlock = ^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        };
    }];
    
    [self.viewModel.commentFailureObject subscribeNext:^(NSString *message) {
        @strongify(self)
        if (!self.sendingHUD.isHidden) {
            [self.sendingHUD hide:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        
        if (!self.sendingHUD.isHidden) {
            [self.sendingHUD hide:YES];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"starValueChanged" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         NSDictionary *userInfo = notification.userInfo;
         @strongify(self)
         self.viewModel.score = userInfo[@"value"];
         
     }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SelectImage" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
       
        @strongify(self)
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
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ShowImage" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        ShowImageViewController *showImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowImageViewController"];
        showImageVC.image = userInfo[@"image"];
        [self.navigationController pushViewController:showImageVC animated:NO];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"contentChanged" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        self.viewModel.commentString = userInfo[@"content"];
    }];
    
}

- (void)onClickEvent {
    
    @weakify(self)
    [[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.viewModel.commentString.length < 1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"至少得评价哦~！";
            [hud hide:YES afterDelay:1.5f];
        }
        else if (self.viewModel.commentString.length > 1 && self.viewModel.commentString.length < 120) {
            [self.viewModel sendCommentWithOrderID:self.orderModel.orderID couponID:self.orderModel.couponID storeID:self.orderModel.storeID];
            
            self.sendingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.sendingHUD.mode = MBProgressHUDModeIndeterminate;
            self.sendingHUD.labelText = @"正在发送";
            [self.sendingHUD show:YES];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"评价不能超过120字~！";
            [hud hide:YES afterDelay:1.5f];
        }
    }];

}


- (void)configureTableView {
    
    //设置多余的seperator
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}

- (void)dealloc {
    [self.sendingHUD removeFromSuperview];
    self.sendingHUD = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 164;
    }
    else {
        if (self.viewModel.imageArray.count < 4) {
            return 215;
        }
        else {
            return 300;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CouponCommentDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentDetailHeadCell className]];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.orderModel.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
        cell.titleLabel.text = self.orderModel.storeName;
        cell.describeLabel.text = self.orderModel.resume;
        return cell;
    }
    else {
        CouponCommentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentMessageCell className]];
        cell.imageArray = self.viewModel.imageArray;
        [cell.collectionView reloadData];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        CouponCommentMessageSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:[CouponCommentMessageSectionCell className]];
        return cell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
        [self.viewModel.imageArray addObject:imageToUse];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
