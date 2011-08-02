//
//  LXBlockView.m
//  LXKit
//
//  Created by Luke Iannini on 5/6/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import "LXBlockView.h"


@implementation LXBlockView
@synthesize drawingBlock;

+ (LXBlockView *)blockViewWithFrame:(CGRect)frame 
                              block:(LXDrawingBlock)drawingBlock
{
    LXBlockView *blockView = [[[self alloc] initWithFrame:frame] autorelease];
    blockView.drawingBlock = drawingBlock;
    return blockView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    if (self.drawingBlock) 
    {
        __block UIView *mySelf = self;
        self.drawingBlock(mySelf, rect);
    }
}


- (void)dealloc
{
    [drawingBlock release];
    [super dealloc];
}

@end
