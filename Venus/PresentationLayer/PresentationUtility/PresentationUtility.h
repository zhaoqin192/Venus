//
//  PresentationUtility.h
//  Venus
//
//  Created by zhaoqin on 4/21/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentationUtility : NSObject

+ (void)showTextDialog:(UIView *)view
                  text:(NSString *)text
               success:(void (^)())success;

@end
