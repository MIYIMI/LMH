//
//  KATAFocusView.m
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import "KATAFocusView.h"
#import "BOKUBannerImageButton.h"
#import "AdvVO.h"

@implementation KATAFocusView

@synthesize focusViewDelegate = _focusViewDelegate;
@synthesize focusData = _focusData;
@synthesize focusViews = _focusViews;

- (id)initWithFrame:(CGRect)frame scrollEnabled:(BOOL)can direct:(AniDirect)pDirect aniType:(AniType)pAniType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentPage = 0;
        isAniPlaying = NO;
        _direct = pDirect;
        aniType = pAniType;
        
        self.bounces = NO;
        
        if (_direct != kNoAni) {
            self.scrollEnabled = YES;
            self.pagingEnabled = YES;
            self.directionalLockEnabled = YES;
            self.showsHorizontalScrollIndicator = NO;
            self.showsVerticalScrollIndicator = NO;
        }
        else {
            self.scrollEnabled = NO;
            self.pagingEnabled = NO;
        }
        
        self.delegate = self;
    }
    return self;
}

- (void)setFocusViewDelegate:(id<KATAFocusViewDelegate>)focusViewDelegate
{
    _focusViewDelegate = focusViewDelegate;
    [self initFocusViews];
}

- (void)initFocusViews
{
//  子对象数
    if ([self.focusViewDelegate respondsToSelector:@selector(numbOfFocusView:)]) {
        kNumbImages = [self.focusViewDelegate numbOfFocusView:self];
    }
    
//  初始化建立对象
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:kNumbImages];

    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat xShift = 0;
    CGFloat yShift = 0;
    CGFloat itemW = self.frame.size.width;
    CGFloat itemH = self.frame.size.height;
    if (_direct == kHorz) {
        xOffset = self.frame.size.width;
        yOffset = 0;
    }
    else if (_direct == kVer) {
        xOffset = 0;
        yOffset = self.frame.size.height;
    }
    
    if ([self.focusViewDelegate respondsToSelector:@selector(widthForFocusViewItem:)]) {
        itemW = [self.focusViewDelegate widthForFocusViewItem:self];
    }
    if ([self.focusViewDelegate respondsToSelector:@selector(heightForFocusViewItem:)]) {
        itemH = [self.focusViewDelegate heightForFocusViewItem:self];
    }
    if ([self.focusViewDelegate respondsToSelector:@selector(xShiftForFocusViewItem:)]) {
        xShift = [self.focusViewDelegate xShiftForFocusViewItem:self];
    }
    if ([self.focusViewDelegate respondsToSelector:@selector(yShiftForFocusViewItem:)]) {
        yShift = [self.focusViewDelegate yShiftForFocusViewItem:self];
    }
    
    for (NSUInteger i = 0; i < kNumbImages; i++) {
        BOKUBannerImageButton *item = [[BOKUBannerImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loading"]];
        
        item.frame = CGRectMake(i * xOffset + xShift, i * yOffset + yShift, itemW, itemH);
        item.contentMode = UIViewContentModeScaleAspectFill;
        item.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [item.imageView setClipsToBounds:YES];
        
        if ([self.focusViewDelegate respondsToSelector:@selector(viewContentModeForView:)]) {
            item.contentMode = [self.focusViewDelegate viewContentModeForView:self];
            item.imageView.contentMode = [self.focusViewDelegate viewContentModeForView:self];
        }
        
        if ([self.focusViewDelegate respondsToSelector:@selector(canClickForView:)]) {
            item.userInteractionEnabled = [self.focusViewDelegate canClickForView:self];
        }
        
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self insertSubview:item atIndex:0];
        [views addObject:item];
    }
    
    self.focusViews = views;
    self.contentSize = CGSizeMake(xOffset * kNumbImages, yOffset * kNumbImages);
    [self loadFocusViewWithPage:0];
    [self loadFocusViewWithPage:1];
}

- (void)loadFocusViewWithPage:(NSInteger)page
{
    if (page < 0) {
        return;
    }
    
    if (page >= kNumbImages) {
        return;
    }
    
    BOKUBannerImageButton *item = [self.focusViews objectAtIndex:page];
    
    if (!item.imageURL) {
        if (self.focusViewDelegate && [self.focusViewDelegate respondsToSelector:@selector(imgUrlAtIndex:focusView:)]) {
            NSString *urlStr = [self.focusViewDelegate imgUrlAtIndex:page focusView:self];
            item.imageURL = [NSURL URLWithString:urlStr];
//            [item.imageView performSelectorOnMainThread:@selector(setImageURL:) withObject:urlStr waitUntilDone:NO];
        }
    }
    
    if (!item.slider) {
        if (self.focusViewDelegate && [self.focusViewDelegate respondsToSelector:@selector(voAtIndex:focusView:)]) {
            id vo = [self.focusViewDelegate voAtIndex:page focusView:self];
            if ([vo isKindOfClass:[AdvVO class]]) {
                item.slider = (AdvVO *)vo;
            }
        }
    }
}

- (void)changePage:(NSInteger)page
{
    currentPage = page;
    [self loadFocusViewWithPage:page - 1];
    [self loadFocusViewWithPage:page];
    [self loadFocusViewWithPage:page + 1];
    
//  更新界面
    if (aniType == kScroll) {
        CGRect f = self.frame;
        if (_direct == kHorz) {
            f.origin.x = f.size.width * page;
            f.origin.y = 0;
        }
        else if (_direct == kVer) {
            f.origin.x = 0;
            f.origin.y = f.size.height * page;
        }
        [self setContentOffset:f.origin animated:YES];
        
        isAniPlaying = YES;
    }
    else if (aniType == kFade) {
//      fade animate
    }
}

- (void)run
{
    if (!self.isDragging && !self.isDecelerating) {
        currentPage++;
        if (currentPage == kNumbImages) {
            currentPage = 0;
        }
//      Auto Scroll
        [self changePage:currentPage];
    }
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isAniPlaying) {
        return;
    }
    
    CGFloat pageWidth = self.frame.size.width;
    CGFloat pageHeight = self.frame.size.height;
    
    NSInteger page = currentPage;
    
    if (_direct == kHorz) {
        page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }
    else if (_direct == kVer) {
        page = floor((self.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    }
    
    if (page != currentPage && [self.focusViewDelegate respondsToSelector:@selector(updateCurrentPage:focusView:)]) {
        [self.focusViewDelegate updateCurrentPage:page focusView:self];
    }
    currentPage = page;
    
    [self loadFocusViewWithPage:page - 1];
    [self loadFocusViewWithPage:page];
    [self loadFocusViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isAniPlaying = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isAniPlaying = NO;
}

- (void)clickItem:(id)sender
{
    NSInteger idx = [self.focusViews indexOfObject:sender];
    if (self.focusViewDelegate && [self.focusViewDelegate respondsToSelector:@selector(clickFocusItemAtIndex:focusView:)]) {
        [self.focusViewDelegate clickFocusItemAtIndex:idx focusView:self];
    }
    if (self.focusViewDelegate && [self.focusViewDelegate respondsToSelector:@selector(clickFocusItemAtButton:)]) {
        [self.focusViewDelegate clickFocusItemAtButton:sender];
    }
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
