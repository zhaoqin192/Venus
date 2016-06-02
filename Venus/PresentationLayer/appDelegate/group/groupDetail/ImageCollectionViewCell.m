//
//  ImageCollectionViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [self.image setUserInteractionEnabled:YES];
    [self.image addGestureRecognizer:singleTap];
    
}

- (void)imageTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCommentImage" object:nil userInfo:@{@"image": self.image.image}];
}

@end
