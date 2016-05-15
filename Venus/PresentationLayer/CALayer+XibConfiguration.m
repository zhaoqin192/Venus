//
//  CALayer+XibConfiguration.m
//  Venus
//
//  Created by EdwinZhou on 16/5/15.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color {
    
    self.borderColor = color.CGColor;
    
}

-(UIColor*)borderUIColor {
    
    return [UIColor colorWithCGColor:self.borderColor];
    
}

@end
