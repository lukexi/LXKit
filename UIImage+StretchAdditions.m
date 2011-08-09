//
//  UIImage+Additions.m
//  Explor
//
//  Created by Luke Iannini on 11/23/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "UIImage+StretchAdditions.h"


@implementation UIImage (Additions)

- (UIImage *)hc_horizontallyStretchableImage
{
    return [self stretchableImageWithLeftCapWidth:floor(self.size.width / 2) 
                                     topCapHeight:0];
}

- (UIImage *)hc_fullyStretchableImage
{
    return [self stretchableImageWithLeftCapWidth:floor(self.size.width / 2) 
                                     topCapHeight:floor(self.size.height / 2) ];
}

@end
