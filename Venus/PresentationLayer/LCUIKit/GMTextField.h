//
//  GMTextField.h
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMTextField : UITextField
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selectImageName;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIView *lineView;
@end
