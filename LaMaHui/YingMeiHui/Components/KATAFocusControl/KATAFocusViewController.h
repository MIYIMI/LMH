//
//  KATAFocusViewController.h
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "KATABasePageControl.h"
#import "KATAFocusView.h"

@protocol KATAFocusViewControllerDelegate;

@interface KATAFocusViewController : UIViewController <KATAFocusPageControlDelegate, KATAFocusViewDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSArray *ds;
@property (strong, nonatomic) KATAFocusView *focusView;
@property (strong, nonatomic) KATABasePageControl *pageControl;
@property (assign, nonatomic) id<KATAFocusViewControllerDelegate> focusViewControllerDelegate;
@property (assign, nonatomic) CGFloat pictureInterval;

- (void)runAni;
- (id)initWithData:(NSArray *)data;

@end

@protocol KATAFocusViewControllerDelegate <NSObject>

@optional
- (void)didClickFocusItemAt:(NSInteger)index;
- (void)didClickFocusItemButton:(id)sender;

@end
