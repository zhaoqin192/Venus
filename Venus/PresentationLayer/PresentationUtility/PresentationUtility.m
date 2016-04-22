//
//  PresentationUtility.m
//  Venus
//
//  Created by zhaoqin on 4/21/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "PresentationUtility.h"
#import "MBProgressHUD.h"

@implementation PresentationUtility

+ (void)showTextDialog:(UIView *)view
                  text:(NSString *)text
               success:(void (^)())success{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1.5);
    } completionBlock:^{
        //操作执行完后取消对话框
        if(success != nil){
            success(); 
        }
        [hud removeFromSuperview];
    }];
}

@end
