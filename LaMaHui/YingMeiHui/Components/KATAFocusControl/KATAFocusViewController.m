//
//  KATAFocusViewController.m
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "KATAFocusViewController.h"

@interface KATAFocusViewController ()

@end

@implementation KATAFocusViewController

@synthesize timer = _timer;
@synthesize items = _items;
@synthesize ds = _ds;
@synthesize focusViewControllerDelegate = _focusViewControllerDelegate;
@synthesize focusView = _focusView;
@synthesize pageControl = _pageControl;
@synthesize pictureInterval = _pictureInterval;

- (id)initWithData:(NSArray *)data
{
    self = [super init];
    if (self) {
        self.ds = data;
        self.pictureInterval = 8.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self performSelector:@selector(runAni) withObject:nil afterDelay:self.pictureInterval];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Run Animate
- (void)runAni
{
    [self.focusView run];
    [self.pageControl run];
    
    [self performSelector:@selector(runAni) withObject:nil afterDelay:self.pictureInterval];
}

#pragma mark - Focus Delegate
- (void)clickFocusItemAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView
{
    if (self.focusViewControllerDelegate && [self.focusViewControllerDelegate respondsToSelector:@selector(didClickFocusItemAt:)]) {
        [self.focusViewControllerDelegate didClickFocusItemAt:index];
    }
}

- (void)clickFocusItemAtButton:(id)sender
{
    if (self.focusViewControllerDelegate && [self.focusViewControllerDelegate respondsToSelector:@selector(didClickFocusItemButton:)]) {
        [self.focusViewControllerDelegate didClickFocusItemButton:sender];
    }
}

- (NSInteger)numbOfFocusView:(KATAFocusView *)focusView
{
    return [self.ds count];
}

- (NSString *)imgUrlAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView
{
    return nil;
}

- (id)voAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView
{
    return nil;
}

- (void)updateCurrentPage:(NSInteger)page focusView:(KATAFocusView *)focusView
{
    [self.pageControl changePage:page];
}

#pragma mark - Page Control Delegate
- (NSUInteger)numbOfPageControls:(KATABasePageControl *)pageControl
{
    return [self.ds count];
}

- (void)updateCurrentPge:(NSInteger)page focusPageControl:(KATABasePageControl *)focusPageControl
{
    [self.focusView changePage:page];
}

- (id)contentOfPageControl:(KATABasePageControl *)pageControl atPage:(NSInteger)page
{
    return nil;
}

@end
