//
//  BeautifulCommitView.h
//  Venus
//
//  Created by 王霄 on 16/5/22.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautifulCommitView : UIView
+ (instancetype) commitView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) void(^sendButtonTapped)(NSString *text);
@end
