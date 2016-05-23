//
//  WXInformationDetailViewController.h
//  Mars
//
//  Created by 王霄 on 16/5/3.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WXInformationDetailViewController : UIViewController
@property (nonatomic ,copy) NSString *myTitle;
//@property (nonatomic ,copy) void(^returnString)(NSString *text);
@property (nonatomic ,copy) NSString *originContent;
@property (nonatomic, strong) RACSubject *delegateSignal;
@end
