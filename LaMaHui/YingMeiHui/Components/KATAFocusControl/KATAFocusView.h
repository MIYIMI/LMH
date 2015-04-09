//
//  KATAFocusView.h
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kHorz,
	kVer,
	kNoAni
} AniDirect;

typedef enum{
	kScroll,
	kFade
} AniType;

@protocol KATAFocusViewDelegate;

@interface KATAFocusView : UIScrollView <UIScrollViewDelegate>
{
    NSInteger currentPage;
    NSInteger kNumbImages;
    
    BOOL isAniPlaying;
    
    AniDirect _direct;
    AniType aniType;
}

@property (assign, nonatomic) id<KATAFocusViewDelegate> focusViewDelegate;
@property (strong, nonatomic) NSArray *focusData;
@property (strong, nonatomic) NSMutableArray *focusViews;

- (id)initWithFrame:(CGRect)frame scrollEnabled:(BOOL)can direct:(AniDirect)pDirect aniType:(AniType)pAniType;
- (void)initFocusViews;
- (void)loadFocusViewWithPage:(NSInteger)page;
- (void)clickItem:(id)sender;
- (void)changePage:(NSInteger)page;
- (void)run;

@end

@protocol KATAFocusViewDelegate <NSObject>

- (void)clickFocusItemAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView;
- (void)clickFocusItemAtButton:(id)sender;
- (void)updateCurrentPage:(NSInteger)page focusView:(KATAFocusView *)focusView;
- (NSInteger)numbOfFocusView:(KATAFocusView *)focusView;
- (NSString *)imgUrlAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView;

@optional
- (UIViewContentMode)viewContentModeForView:(KATAFocusView *)focusView;
- (CGFloat)widthForFocusViewItem:(KATAFocusView *)focusView;
- (CGFloat)heightForFocusViewItem:(KATAFocusView *)focusView;
- (CGFloat)xShiftForFocusViewItem:(KATAFocusView *)focusView;
- (CGFloat)yShiftForFocusViewItem:(KATAFocusView *)focusView;
- (BOOL)canClickForView:(KATAFocusView *)focusView;
- (id)voAtIndex:(NSInteger)index focusView:(KATAFocusView *)focusView;

@end