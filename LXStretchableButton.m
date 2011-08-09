//
//  HCStretchableButton.m
//  Explor
//
//  Created by Luke Iannini on 10/28/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import "LXStretchableButton.h"
#import "UIImage+StretchAdditions.h"

@implementation LXStretchableButton
@synthesize imageViewToAdd;

- (void)dealloc
{
    [imageViewToAdd release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [self setStretchableImage:[self backgroundImageForState:UIControlStateNormal] 
                     forState:UIControlStateNormal];
    
    [self setStretchableImage:[self backgroundImageForState:UIControlStateHighlighted] 
                     forState:UIControlStateHighlighted];
    
    [self setStretchableImage:[self backgroundImageForState:UIControlStateSelected] 
                     forState:UIControlStateSelected];
    
    // Allows one to drop an image in Interface Builder on top of the button where you'd like it and have it added to the button as a subview to be highlighted when it is.
    if (self.imageViewToAdd)
    {
        self.imageViewToAdd.frame = [self convertRect:self.imageViewToAdd.frame 
                                             fromView:self.imageViewToAdd.superview];
        [self addSubview:self.imageViewToAdd];
    }
}

- (void)setHighlighted:(BOOL)flag
{
    [super setHighlighted:flag];
    [self.imageViewToAdd setHighlighted:flag];
}

- (void)setStretchableImage:(UIImage *)image forState:(UIControlState)aState
{
    [self setBackgroundImage:[image hc_horizontallyStretchableImage] forState:aState];
}

@end
