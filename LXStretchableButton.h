//
//  HCStretchableButton.h
//  Explor
//
//  Created by Luke Iannini on 10/28/10.
//  Copyright 2010 Hello, Chair Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LXStretchableButton : UIButton 

- (void)setStretchableImage:(UIImage *)image forState:(UIControlState)aState;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewToAdd;

@end
