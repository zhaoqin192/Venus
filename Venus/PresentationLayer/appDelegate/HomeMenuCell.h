//
//  HomeMenuCell.h
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZMTBtnView.h"

@protocol HomeMenuCellDelegate <NSObject>


- (void)enterSubViewController:(NSInteger) menuNumber;

@end

@interface HomeMenuCell : UITableViewCell


@property (nonatomic, weak) id<HomeMenuCellDelegate> delegate;

@property (nonatomic ,copy) void(^buttonClickedWithTag)(NSInteger *tag);
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;

@end

