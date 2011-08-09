//
//  BSPreviewScrollView.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class LXPreviewScrollView;

@protocol LXPreviewScrollViewDelegate <NSObject>
@required
- (UIView *)previewScrollView:(LXPreviewScrollView *)aPreviewView viewForItemAtIndex:(NSUInteger)index;
- (NSUInteger)previewScrollViewItemCount:(LXPreviewScrollView *)aPreviewView;

@optional
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView;

@end


@interface LXPreviewScrollView : UIView <UIScrollViewDelegate> 
{
	BOOL firstLayout;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet id <LXPreviewScrollViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, retain) NSMutableArray *scrollViewPages;
@property (nonatomic) BOOL verticalScrolling;
@property (nonatomic) BOOL preview;
@property (nonatomic) CGRect leftTapRect;
@property (nonatomic) CGRect rightTapRect;
@property (nonatomic) NSUInteger loadNeighboringPagesToDistance;

- (id)initWithFrame:(CGRect)frame pageSize:(CGSize)size;
- (int)currentPage;
- (void)reloadData;
- (void)removePageAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
