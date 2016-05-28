//
//  Activity.h
//  Venus
//
//  Created by 王霄 on 16/5/14.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger end_time;
@end
