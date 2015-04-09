//
//  KTFilterBgView.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTFilterBgView.h"

#define SEGMENTHEIGHT           35

@interface KTTriArrow : UIView

@end

@implementation KTTriArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetRGBFillColor(ctx, 0.90f, 0.90f, 0.90f, 1.0f);
    CGFloat fpW = CGRectGetWidth(rect);
    CGFloat fpH = CGRectGetHeight(rect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, fpH);
    CGPathAddLineToPoint(path, nil, fpW/2.0, 0);
    CGPathAddLineToPoint(path, nil, fpW, fpH);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CGPathRelease(path);
    
    CGContextRestoreGState(ctx);
}

@end

@interface KTFilterBgView ()
{
    CGFloat _xoffset;
    KTTriArrow * _arrow;
    UIView *_footer;
}

@end

@implementation KTFilterBgView

- (id)initWithFrame:(CGRect)frame andXOffset:(CGFloat)pXOffset
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        _xoffset = pXOffset;
        
        _arrow = [[KTTriArrow alloc] initWithFrame:CGRectMake(_xoffset, SEGMENTHEIGHT - 5.0f, 10.0f, 5.0f)];
        [_arrow setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:_arrow];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SEGMENTHEIGHT, CGRectGetWidth(frame), 44.0f)];
        [_bgView setBackgroundColor:[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.0f]];
        
        if (!_footer) {
            _footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame), CGRectGetWidth(_bgView.frame), 2)];
            [_footer setBackgroundColor:[UIColor colorWithRed:1 green:0.41 blue:0.01 alpha:1]];
        }
        [_bgView addSubview:_footer];
        
        [self addSubview:_bgView];
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = _bgView.center;
        
        [_loadingView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        
        [self addSubview:_loadingView];
        
        [_loadingView startAnimating];
    }
    return self;
}

- (void)setOffsetX:(CGFloat)pXoffset
{
    _xoffset = pXoffset;
    [_arrow setFrame:CGRectMake(_xoffset, SEGMENTHEIGHT - 5.0f, 10.0f, 5.0f)];
}

- (void)setFooterOffsetY:(CGFloat)pYoffset
{
    [_footer setFrame:CGRectMake(0, pYoffset, CGRectGetWidth(_bgView.frame), 2)];
}

@end
