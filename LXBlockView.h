//
//  LXBlockView.h
//  LXKit
//
//  Created by Luke Iannini on 5/6/11.
//  Copyright 2011 Eeoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXDrawingBlock)(UIView *blockView, CGRect dirtyRect);

@interface LXBlockView : UIView {
    
}

+ (LXBlockView *)blockViewWithFrame:(CGRect)frame 
                              block:(LXDrawingBlock)drawingBlock;

@property (nonatomic, copy) LXDrawingBlock drawingBlock;

@end
