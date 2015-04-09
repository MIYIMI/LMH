//
//  KATABasePageControl.m
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "KATABasePageControl.h"

@implementation KATABasePageControl

@synthesize views = _views;
@synthesize focusPageControlDelegate = _focusPageControlDelegate;

- (id)initWithFrame:(CGRect)frame canClick:(BOOL)can
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        kCurrentPage = 0;
        canClick = can;
    }
    return self;
}

- (void)setFocusPageControlDelegate:(id<KATAFocusPageControlDelegate>)focusPageControlDelegate
{
    _focusPageControlDelegate = focusPageControlDelegate;
    
    kNumbOfControls = 0;
    if ([self.focusPageControlDelegate respondsToSelector:@selector(numbOfPageControls:)]) {
        kNumbOfControls = [self.focusPageControlDelegate numbOfPageControls:self];
    }
}

- (void)didClickItem:(id)sender
{
    NSInteger page = [self.views indexOfObject:sender];
    
    [self changePage:page];
    if (self.focusPageControlDelegate && [self.focusPageControlDelegate respondsToSelector:@selector(updateCurrentPge:focusPageControl:)]) {
        [self.focusPageControlDelegate updateCurrentPge:page focusPageControl:self];
    }
}

- (void)run
{
    kCurrentPage++;
    if (kCurrentPage == kNumbOfControls) {
        kCurrentPage = 0;
        
    }
    [self updateState];
}

- (void)changePage:(NSInteger)page
{
    kCurrentPage = page;
    [self updateState];
}

- (void)updateState
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
