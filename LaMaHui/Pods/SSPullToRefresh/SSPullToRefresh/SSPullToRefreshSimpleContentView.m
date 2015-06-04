//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012-2014 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshSimpleContentView.h"
#define ScreenW   [UIScreen mainScreen].bounds.size.width

@implementation SSPullToRefreshSimpleContentView
{
    UIImageView *updateView;
    UIImageView *boultVIew;
}
@synthesize statusLabel = _statusLabel;
@synthesize activityIndicatorView = _activityIndicatorView;


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
//        CGFloat width = self.window.frame.size.width;
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW/2 - 65, 34.0f, 150, 20.0f)];
//        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _statusLabel.textColor = [UIColor colorWithRed:255/255.0 green:74/255.0 blue:166/255.0 alpha:1];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        updateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -55, ScreenW, ScreenW/360*86)];
        updateView.image = [UIImage imageNamed:@"down_redraw"];
        [self addSubview:updateView];
        
        boultVIew = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_statusLabel.frame)-20, 35.0f, 20.0f, 20.0f)];
        [self addSubview:boultVIew];
        boultVIew.image = [UIImage imageNamed:@"boult_down"];

        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(CGRectGetMinX(_statusLabel.frame)-20, 35.0f, 20.0f, 20.0f);
        [self addSubview:_activityIndicatorView];
    }
    return self;
}

#pragma mark - SSPullToRefreshContentView

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
    switch (state) {
        case SSPullToRefreshViewStateReady: {
            self.statusLabel.text = @"专注高性价比母婴特卖";// 上NSLocalizedString(@"Release to refresh…", nil);
            [self.activityIndicatorView stopAnimating];
            
            [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationDelegate:self];
            boultVIew.transform = CGAffineTransformMakeRotation((180.0f * M_PI) / 180.0f);
            [UIView commitAnimations];
//            boultVIew.image = [UIImage imageNamed:@"boult_up"];
            break;
        }
            
        case SSPullToRefreshViewStateNormal: {
            self.statusLabel.text = @"专注高性价比母婴特卖";// 下NSLocalizedString(@"Pull down to refresh…", nil);
            [self.activityIndicatorView stopAnimating];
            
            [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];
            [UIView setAnimationDuration:0.5f];
            /* 回到原始旋转 */
            boultVIew.transform = CGAffineTransformIdentity;
            [UIView commitAnimations];
            
            boultVIew.image = [UIImage imageNamed:@"boult_down"];
            break;
        }
            
        case SSPullToRefreshViewStateLoading:
        case SSPullToRefreshViewStateClosing: {
            self.statusLabel.text = @"专注高性价比母婴特卖";//NSLocalizedString(@"Loading…", nil);
            [self.activityIndicatorView startAnimating];
            boultVIew.image = nil;
            break;
        }
    }
}

- (void)setLastUpdatedAt:(NSDate *)date withPullToRefreshView:(SSPullToRefreshView *)view {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    
//    self.lastUpdatedAtLabel.text = @"更懂辣妈的特卖网站";
    //self.lastUpdatedAtLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", nil), [dateFormatter stringForObjectValue:date]];
}


@end
