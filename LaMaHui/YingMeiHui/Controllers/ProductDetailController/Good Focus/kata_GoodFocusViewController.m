//
//  kata_GoodFocusViewController.m
//  SanDing
//
//  Created by 林 程宇 on 13-6-7.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "kata_GoodFocusViewController.h"
#import "KATAFocusView.h"
#import "kata_GoodFocusPageControl.h"

@interface kata_GoodFocusViewController ()

@end

@implementation kata_GoodFocusViewController

- (id)initWithData:(NSArray *)data
{
    self = [super initWithData:data];
    if (self) {
        // Custom initialization
        self.pictureInterval = 36000000.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat focusWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat focusHeight = ScreenW;
    
    //  initialization of focus view
    self.view.frame = CGRectMake(0, 0, focusWidth, focusHeight);
    KATAFocusView *fv = [[KATAFocusView alloc] initWithFrame:CGRectMake(0, 0, focusWidth, focusHeight) scrollEnabled:YES direct:kHorz aniType:kScroll];
    fv.focusViewDelegate = self;
    
    [self.view addSubview:fv];
    self.focusView = fv;
    
    //  initialization of page control
//    CGRect pageControlFrame = CGRectMake(0, focusHeight - 29, focusWidth, 29);
    CGRect pageControlFrame = CGRectMake(0, focusHeight - 25, focusWidth, 25);
    kata_GoodFocusPageControl *goodPageControl = [[kata_GoodFocusPageControl alloc] initWithFrame:pageControlFrame canClick:NO];
    goodPageControl.focusPageControlDelegate = self;
    
    [self.view addSubview:goodPageControl];
    self.pageControl = goodPageControl;
    
    [self.timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FocusView Delegate & Page Control Delegate
- (NSString *)imgUrlAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView
{
    return [self.ds objectAtIndex:index];
}

- (UIViewContentMode)viewContentModeForView:(KATAFocusView *)focusView
{
    return UIViewContentModeScaleAspectFit;
}

//- (CGFloat)widthForFocusViewItem:(KATAFocusView *)focusView
//{
//    return 200;
//}
//
//- (CGFloat)heightForFocusViewItem:(KATAFocusView *)focusView
//{
//    return 200;
//}
//
//- (CGFloat)xShiftForFocusViewItem:(KATAFocusView *)focusView
//{
//    return 60;
//}
//
//- (CGFloat)yShiftForFocusViewItem:(KATAFocusView *)focusView
//{
//    return 5;
//}

@end
