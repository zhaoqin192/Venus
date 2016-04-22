//
//  WXTextField.h
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMTextField;
@interface WXTextField : UIView
@property (weak, nonatomic) IBOutlet GMTextField *textField;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selectImageName;
@property (nonatomic, copy) NSString *placeHoleder;

+ (instancetype)fetchTextView;
@end
