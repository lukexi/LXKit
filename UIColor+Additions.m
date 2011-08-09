//
//  UIColor+Additions.m
//  Explor
//
//  Created by Luke Iannini on 4/13/11.
//  Copyright 2011 Hello, Chair Inc. All rights reserved.
//

#import "UIColor+Additions.h"



@implementation UIColor (UIColor_Additions)

+ (UIColor *)lx_randomColor
{
    CGFloat hue = ((double)arc4random() / ARC4RANDOM_MAX);
    return [UIColor colorWithHue:hue
                      saturation:0.5 
                      brightness:1 
                           alpha:1];
}

@end
