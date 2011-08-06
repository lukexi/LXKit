//
//  UIView+FrameEditing.m
//  FilmBuff
//
//  Created by Corey Johnson on 11/12/08.
//  Copyright 2008 Probably Interactive. All rights reserved.
//

#import "UIView+FrameAdditions.h"


@implementation UIView (FrameEditing)

// Get Methods
// -----------
- (CGFloat)frameWidth 
{
	return self.frame.size.width;
}

- (CGFloat)frameHeight 
{
	return self.frame.size.height;
}

- (CGFloat)frameTop 
{
	return self.frameY;
}

- (CGFloat)frameBottom 
{
	return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (CGFloat)frameLeft
{
	return self.frameX;
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (CGFloat)frameRight 
{
	return self.frame.origin.x + self.frame.size.width;
}


// Set Methods
// -----------
- (UIView *)addToX:(CGFloat)value 
{
	CGRect frame = self.frame;
	frame.origin.x += value;	
	self.frame = frame;	
	return self;
}

- (UIView *)addToY:(CGFloat)value 
{
	CGRect frame = self.frame;
	frame.origin.y += value;	
	self.frame = frame;	
	return self;
}

- (UIView *)addToWidth:(CGFloat)value 
{
	CGRect frame = self.frame;
	frame.size.width += value;	
	self.frame = frame;	
	return self;
}

- (UIView *)addToHeight:(CGFloat)value 
{
	CGRect frame = self.frame;
	frame.size.height += value;	
	self.frame = frame;	
	return self;
}

- (UIView *)strechFrameTop:(CGFloat)top 
{
	CGRect frame = self.frame;	
	frame.size.height = (frame.origin.y + frame.size.height) - top;	
	frame.origin.y = top;
	self.frame = frame;	
	return self;
}

- (UIView *)strechFrameBottom:(CGFloat)bottom 
{
	CGRect frame = self.frame;
	frame.size.height = bottom - frame.origin.y;	
	self.frame = frame;	
	return self;
}

- (void)setFrameX:(CGFloat)x 
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	
	self.frame = frame;	
}

- (void)setFrameY:(CGFloat)y 
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	
	self.frame = frame;
}

- (void)setFrameWidth:(CGFloat)width 
{
	CGRect frame = self.frame;
	frame.size.width = width;
	
	self.frame = frame;
}

- (void)setFrameHeight:(CGFloat)height 
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setFrameLeft:(CGFloat)left
{
    [self setFrameX:left];
}

- (void)setFrameRight:(CGFloat)right 
{
    CGRect frame = self.frame;	
	frame.origin.x = right - self.frame.size.width;
	self.frame = frame;	
}

- (void)setFrameBottom:(CGFloat)bottom 
{
    CGRect frame = self.frame;	
	frame.origin.y = bottom - self.frame.size.height;
	self.frame = frame;	
}

- (void)setFrameTop:(CGFloat)top 
{
    [self setFrameY:top];
}

@end
