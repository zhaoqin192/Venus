//
//  GMMeShowIconViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeShowIconViewController.h"

@interface GMMeShowIconViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GMMeShowIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头像";
    if (self.imgUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    }
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存到相册" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemTapped)];
        right;
    });
}

- (void)rightItemTapped {
    if (self.imageView) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
    if (error != NULL) {
        [PresentationUtility showTextDialog:self.view text:@"保存图片失败" success:nil];
    }
    else {
        [PresentationUtility showTextDialog:self.view text:@"保存图片成功" success:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
