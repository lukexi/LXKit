//
//  UIView+FrameEditing.h
//  FilmBuff
//
//  Created by Corey Johnson on 11/12/08.
//  Copyright 2008 Probably Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (FrameEditing)

- (UIView *)addToX:(CGFloat)value;
- (UIView *)addToY:(CGFloat)value;
- (UIView *)addToHeight:(CGFloat)value;
- (UIView *)addToWidth:(CGFloat)value;

- (UIView *)strechFrameBottom:(CGFloat)bottom;
- (UIView *)strechFrameTop:(CGFloat)top;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameWidth;

@property (nonatomic) CGFloat frameLeft;
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;
@property (nonatomic) CGFloat frameTop;

@end
