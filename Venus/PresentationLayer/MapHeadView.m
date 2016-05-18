//
//  MapHeadView.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MapHeadView.h"

@interface MapHeadView ()
@property (weak, nonatomic) IBOutlet GMLabel *newsLabel;
@property (weak, nonatomic) IBOutlet GMLabel *discountLabel;

@end

@implementation MapHeadView

+ (instancetype)headView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.newsLabel.userInteractionEnabled = YES;
    [self.newsLabel bk_whenTapped:^{
        if (self.newsLabelTapped) {
            self.newsLabelTapped();
        }
    }];
    
    self.discountLabel.userInteractionEnabled = YES;
    [self.discountLabel bk_whenTapped:^{
        if (self.discountLabelTapped) {
            self.discountLabelTapped();
        }
    }];
}

@end
