//
//  SBChartView.m
//  Nudge
//
//  Created by Terry Worona on 9/4/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "SBChartView.h"

CGFloat const kSBChartViewDefaultAnimationDuration = 0.25f;

// Color (SBChartSelectionView)
static UIColor *kSBChartSelectionViewDefaultBgColor = nil;

@interface SBChartView ()

- (void)validateHeaderAndFooterHeights;

@end

@implementation SBChartView

#pragma mark - Alloc/Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Public

- (void)reloadData
{
    // Override
}

#pragma mark - Helpers

- (void)validateHeaderAndFooterHeights
{
    NSAssert((self.headerView.bounds.size.height + self.footerView.bounds.size.height) <= self.bounds.size.height, @"SBChartView // the combined height of the footer and header can not be greater than the total height of the chart.");
}

#pragma mark - Setters

- (void)setHeaderView:(UIView *)headerView
{
    if (_headerView)
    {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    _headerView = headerView;
    
    [self validateHeaderAndFooterHeights];
    
    [self addSubview:_headerView];
    [self reloadData];
}

- (void)setFooterView:(UIView *)footerView
{
    if (_footerView)
    {
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _footerView = footerView;
    
    [self validateHeaderAndFooterHeights];
    
    [self addSubview:_footerView];
    [self reloadData];
}

- (void)setState:(SBChartViewState)state animated:(BOOL)animated callback:(void (^)())callback
{
    if (_state == state)
    {
        return;
    }
    
    _state = state;
    
    // Override
}

- (void)setState:(SBChartViewState)state animated:(BOOL)animated
{
    [self setState:state animated:animated callback:nil];
}

- (void)setState:(SBChartViewState)state
{
    [self setState:state animated:NO];
}

@end

@implementation SBChartSelectionView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [SBChartSelectionView class])
	{
		kSBChartSelectionViewDefaultBgColor = [UIColor whiteColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = nil;
    if (self.bgColor != nil)
    {
        colors = @[(__bridge id)self.bgColor.CGColor, (__bridge id)[self.bgColor colorWithAlphaComponent:0.0].CGColor];
    }
    else
    {
        colors = @[(__bridge id)kSBChartSelectionViewDefaultBgColor.CGColor, (__bridge id)[kSBChartSelectionViewDefaultBgColor colorWithAlphaComponent:0.0].CGColor];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    CGContextSaveGState(context);
    {
        CGContextAddRect(context, rect);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    }
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - Setters

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    [self setNeedsDisplay];
}

@end
