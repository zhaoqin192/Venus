//
//  SearchHotCollectionViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchHotCollectionViewCell.h"

@implementation SearchHotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    @weakify(self)
    [[self.titleLabel rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
       
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectHotSearch" object:nil userInfo:@{@"hotSearch": self.titleLabel.titleLabel.text}];
        
    }];
    
}


@end
