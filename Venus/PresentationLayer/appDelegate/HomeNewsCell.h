//
//  HomeNewsCell.h
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarqueeLabel;

@interface HomeNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MarqueeLabel *marqueeLabel;

@property (nonatomic, strong) NSArray *headlineArray;

- (void)showHeadline;

@end
