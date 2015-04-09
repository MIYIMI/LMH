//
//  KATABasePageControl.h
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KATAFocusPageControlDelegate;

@interface KATABasePageControl : UIView
{
    NSUInteger kNumbOfControls;
    NSInteger kCurrentPage;
    
    BOOL canClick;
}

@property (assign, nonatomic) id<KATAFocusPageControlDelegate> focusPageControlDelegate;
@property (strong, nonatomic) NSArray *views;

- (id)initWithFrame:(CGRect)frame canClick:(BOOL)can;
- (void)updateState;
- (void)run;
- (void)changePage:(NSInteger)page;
- (void)didClickItem:(id)sender;

@end

@protocol KATAFocusPageControlDelegate <NSObject>

- (NSUInteger)numbOfPageControls:(KATABasePageControl *)pageControl;
- (id)contentOfPageControl:(KATABasePageControl *)pageControl atPage:(NSInteger)page;
- (void)updateCurrentPge:(NSInteger)page focusPageControl:(KATABasePageControl *)focusPageControl;

@end
