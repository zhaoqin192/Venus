//
//  WXTextField.m
//  Venus
//
//  Created by 王霄 on 16/4/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXTextField.h"
#import "GMTextField.h"

@interface WXTextField ()

@property (weak, nonatomic) IBOutlet GMTextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation WXTextField

+ (instancetype)fetchTextField{
    WXTextField *view = [[[UINib nibWithNibName:@"WXTextField" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    [view setup];
    return view;
}


- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.textField.imageView = self.imageView;
    self.textField.lineView = self.lineView;
    self.textField.textColor = GMTipFontColor;
}

- (void)setImageName:(NSString *)imageName{
    self.textField.imageName = imageName;
}

- (void)setSelectImageName:(NSString *)selectImageName{
    self.textField.selectImageName = selectImageName;
}

- (void)setPlaceHoleder:(NSString *)placeHoleder{
    self.textField.placeholder = placeHoleder;
}
@end
