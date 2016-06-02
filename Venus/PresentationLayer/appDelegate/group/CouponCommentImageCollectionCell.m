//
//  CouponCommentImageCollectionCell.m
//  Venus
//
//  Created by zhaoqin on 5/31/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentImageCollectionCell.h"

@interface CouponCommentImageCollectionCell ()

@end

@implementation CouponCommentImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [[self.imageButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (self.isAdd) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectImage" object:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowImage" object:nil userInfo:@{@"image": self.imageButton.currentImage}];
        }
    }];
}

@end
