//
//  BSPreviewScrollView.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "LXPreviewScrollView.h"
#import "UIView+FrameAdditions.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)

@interface LXPreviewScrollView ()

- (void)commonInit;
- (void)didReceiveMemoryWarning;
- (void)removePageAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end

@implementation LXPreviewScrollView
@synthesize scrollView, pageSize, delegate;
@synthesize scrollViewPages;
@synthesize verticalScrolling, preview;
@synthesize leftTapRect, rightTapRect;
@synthesize loadNeighboringPagesToDistance;
@synthesize pageControl;

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if(self)
	{
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
    self.loadNeighboringPagesToDistance = 1;
    self.preview = YES;
    firstLayout = YES;
    self.leftTapRect = CGRectZero;
    self.rightTapRect = CGRectZero;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
    [self addSubview:scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveMemoryWarning) 
                                                 name:UIApplicationDidReceiveMemoryWarningNotification 
                                               object:nil];
    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)] autorelease];
    tapRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapRecognizer];
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    if (CGRectContainsPoint(self.leftTapRect, location))
    {
        NSInteger previousPage = [self currentPage] - 1;
        if (previousPage >= 0) {
            UIView *previousPageView = [self.scrollViewPages objectAtIndex:previousPage];
            [self.scrollView setContentOffset:CGPointMake(previousPageView.frame.origin.x, 0)
                                     animated:YES];
        }
    }
    else if (CGRectContainsPoint(self.rightTapRect, location))
    {
        NSInteger nextPage = [self currentPage] + 1;
        if (nextPage < [delegate previewScrollViewItemCount:self]) {
            UIView *nextPageView = [self.scrollViewPages objectAtIndex:nextPage];
            [self.scrollView setContentOffset:CGPointMake(nextPageView.frame.origin.x, 0)
                                     animated:YES];
        }
    }
}

- (id)initWithFrame:(CGRect)frame pageSize:(CGSize)size 
{    
    self = [self initWithFrame:frame];
	if (self) 
	{
		self.pageSize = size;
    }
    return self;
}

- (void)loadPage:(NSInteger)page
{
	// Sanity checks
    if (page < 0) return;
    if (page >= [self.scrollViewPages count]) return;
	
	// Check if the page is already loaded
	UIView *view = [self.scrollViewPages objectAtIndex:page];
	
	// if the view is null we request the view from our delegate
	if ((NSNull *)view == [NSNull null]) 
	{
		view = [delegate previewScrollView:self viewForItemAtIndex:page];
		[self.scrollViewPages replaceObjectAtIndex:page withObject:view];
	}
	
	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) 
	{
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
        
        if (verticalScrolling) 
        {
            viewFrame.origin.y = viewFrame.size.height * page;
            viewFrame.origin.x = 0;
        }
        else
        {
            viewFrame.origin.x = viewFrame.size.width * page;
            viewFrame.origin.y = 0;
        }
		
		view.frame = viewFrame;
		
		[self.scrollView addSubview:view];
	}
}

- (void)layoutSubviews
{    
	if (firstLayout)
	{
        
        NSAssert(!CGSizeEqualToSize(pageSize, CGSizeZero), @"Must set pageSize property on HCPreviewScrollView");
		// Position and size the scrollview. It will be centered in the view.
		CGRect scrollViewRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - pageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2);
		 
		scrollView.frame = scrollViewRect;
		scrollView.clipsToBounds = !self.preview; // Important, this creates the "preview"
        
		[self reloadData];
		
		firstLayout = NO;
	}
}

- (void)reloadData
{
    for (UIView *view in self.scrollViewPages) 
    {
        //DLog(@"removing %@", view);
        if ([view isKindOfClass:[UIView class]]) 
        {
            //DLog(@"     removing %@", [view subviews]);
            [view removeFromSuperview];
        }
    }
    
    NSUInteger pageCount = [self.delegate previewScrollViewItemCount:self];
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    self.scrollViewPages = [NSMutableArray arrayWithCapacity:pageCount];
    
    // Fill our pages collection with empty placeholders
    for(int i = 0; i < pageCount; i++)
    {
        [self.scrollViewPages addObject:[NSNull null]];
    }
    
    // Calculate the size of all combined views that we are scrolling through 
    if (verticalScrolling) 
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, pageCount * self.scrollView.frame.size.height);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(pageCount * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    
    // Synthesize a scroll event to load the visible pages and 
    // have our delegate apply any visual changes it may want based on scroll position
    [self scrollViewDidScroll:self.scrollView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) 
    {
		return self.scrollView;
	}
	
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

- (NSInteger)currentPage
{
	// Calculate which page is visible
    NSInteger page = 0;
    if (verticalScrolling) 
    {
        CGFloat pageHeight = scrollView.frame.size.height;
        page = floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    }
    else
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }
	
	return page;
}

- (void)removePageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    UIView *removedView = [scrollViewPages objectAtIndex:index];
    if (animated) 
    {
        [UIView beginAnimations:nil context:removedView];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removePageAnimationDidStop:finished:context:)];
    }
    
    CGFloat removedViewWidth = removedView.frame.size.width;
    CGFloat removedViewHeight = removedView.frame.size.height;
    NSUInteger movedIndexesStart = index + 1;
    NSArray *movedViews = [self.scrollViewPages objectsAtIndexes:
                           [NSIndexSet indexSetWithIndexesInRange:
                            NSMakeRange(movedIndexesStart, [self.scrollViewPages count] - movedIndexesStart)]];
    for (UIView *view in movedViews) 
    {
        if ([view isKindOfClass:[UIView class]]) 
        {
            verticalScrolling ? [view addToY:-removedViewWidth] : [view addToX:-removedViewWidth];
        }
    }
    if (verticalScrolling) 
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - removedViewHeight);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - removedViewWidth, self.scrollView.contentSize.height);
    }
    
    if (animated) 
    {
        [UIView commitAnimations];
    }
    else
    {
        [self removePageAnimationDidStop:nil finished:[NSNumber numberWithBool:YES] context:removedView];
    }
}

- (void)removePageAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *removedPage = (UIView *)context;
    [self.scrollViewPages removeObject:removedPage];
    [removedPage removeFromSuperview];
    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	NSInteger page = [self currentPage];
    
    self.pageControl.currentPage = page;
	
	// Load the visible and neighbouring pages
    [self loadPage:page];
    
    for (NSUInteger i = 0; i <= self.loadNeighboringPagesToDistance; i++) 
    {
        [self loadPage:page-i];
        [self loadPage:page+i];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) 
    {
        [self.delegate scrollViewDidScroll:aScrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) 
    {
        [self.delegate scrollViewWillBeginDragging:aScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) 
    {
        [self.delegate scrollViewDidEndDragging:aScrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) 
    {
        [self.delegate scrollViewDidEndDecelerating:aScrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) 
    {
        [self.delegate scrollViewDidEndScrollingAnimation:aScrollView];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
	// Calculate the current page in scroll view
    NSInteger currentPage = [self currentPage];
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [self.scrollViewPages count]; i++) 
	{
		UIView *viewController = [self.scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[self.scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	[scrollViewPages release];
	[scrollView release];
    [super dealloc];
}


@end
