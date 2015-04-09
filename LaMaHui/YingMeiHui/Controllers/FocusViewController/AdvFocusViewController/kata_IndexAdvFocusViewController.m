//
//  kata_IndexAdvFocusViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_IndexAdvFocusViewController.h"
#import "KATAFocusView.h"
#import "kata_IndexAdvFocusPageControl.h"
#import "AdvVO.h"

#define ADVFOCUSHEIGHT      130

@interface kata_IndexAdvFocusViewController ()

@end

@implementation kata_IndexAdvFocusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat focusWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat focusHeight = ADVFOCUSHEIGHT;
    
    //  initialization of focus view
    self.view.frame = CGRectMake(0, 0, focusWidth, focusHeight);
    KATAFocusView *fv = [[KATAFocusView alloc] initWithFrame:CGRectMake(0, 0, focusWidth, focusHeight) scrollEnabled:YES direct:kHorz aniType:kScroll];
    fv.focusViewDelegate = self;
    
    [self.view addSubview:fv];
    self.focusView = fv;
    
    //  initialization of page control
    CGRect pageControlFrame = CGRectMake(0, focusHeight - 10, focusWidth, 10);
    kata_IndexAdvFocusPageControl *indexPageControl = [[kata_IndexAdvFocusPageControl alloc] initWithFrame:pageControlFrame canClick:NO];
    indexPageControl.focusPageControlDelegate = self;
    
    [self.view addSubview:indexPageControl];
    self.pageControl = indexPageControl;
    
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
    if ([[self.ds objectAtIndex:index] isKindOfClass:[AdvVO class]]) {
        AdvVO *vo =[self.ds objectAtIndex:index];
        return vo.Pic;
    }
    return nil;
}

- (id)voAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView
{
    if ([[self.ds objectAtIndex:index] isKindOfClass:[AdvVO class]]) {
        AdvVO *vo =[self.ds objectAtIndex:index];
        return vo;
    }
    return nil;
}

@end
