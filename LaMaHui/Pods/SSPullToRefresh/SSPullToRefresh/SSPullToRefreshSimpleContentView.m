//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012-2014 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshSimpleContentView.h"

@implementation SSPullToRefreshSimpleContentView
{
    UIImageView *updateView;
}
@synthesize statusLabel = _statusLabel;
@synthesize lastUpdatedAtLabel = _lastUpdatedAtLabel;
@synthesize activityIndicatorView = _activityIndicatorView;


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        CGFloat width = self.window.frame.size.width;
        
        _lastUpdatedAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 9.0f, width, 20.0f)];
        _lastUpdatedAtLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastUpdatedAtLabel.font = [UIFont systemFontOfSize:13.0f];
        _lastUpdatedAtLabel.textColor = [UIColor lightGrayColor];
        _lastUpdatedAtLabel.backgroundColor = [UIColor clearColor];
        _lastUpdatedAtLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdatedAtLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 34.0f, width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
//        UIImageView *updateView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 120)/2, CGRectGetMinY(_lastUpdatedAtLabel.frame) - 100, 120, 90)];
        updateView = [[UIImageView alloc] initWithFrame:CGRectMake(((CGFloat)[UIScreen mainScreen].applicationFrame.size.width-120)/2, CGRectGetMinY(_lastUpdatedAtLabel.frame) - 100, 120, 90)];
        updateView.image = [UIImage imageNamed:@"pulldown"];
        [self addSubview:updateView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(30.0f, 25.0f, 20.0f, 20.0f);
        [self addSubview:_activityIndicatorView];
    }
    return self;
}


//- (void)layoutSubviews {
//	CGSize size = self.bounds.size;
//	self.statusLabel.frame = CGRectMake(20.0f, roundf((size.height - 30.0f) / 2.0f), size.width - 40.0f, 30.0f);
//	self.activityIndicatorView.frame = CGRectMake(roundf((size.width - 20.0f) / 2.0f), roundf((size.height - 20.0f) / 2.0f), 20.0f, 20.0f);
//}


#pragma mark - SSPullToRefreshContentView

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
    switch (state) {
        case SSPullToRefreshViewStateReady: {
            self.statusLabel.text = @"↑ 松开立即刷新";// NSLocalizedString(@"Release to refresh…", nil);
            [self.activityIndicatorView stopAnimating];
            break;
        }
            
        case SSPullToRefreshViewStateNormal: {
            self.statusLabel.text = @"↓ 下拉更新";// NSLocalizedString(@"Pull down to refresh…", nil);
            [self.activityIndicatorView stopAnimating];
            break;
        }
            
        case SSPullToRefreshViewStateLoading:
        case SSPullToRefreshViewStateClosing: {
            self.statusLabel.text = @"加载中...";//NSLocalizedString(@"Loading…", nil);
            [self.activityIndicatorView startAnimating];
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
    
    self.lastUpdatedAtLabel.text = @"更懂辣妈的特卖网站";
    //self.lastUpdatedAtLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", nil), [dateFormatter stringForObjectValue:date]];
}


@end
