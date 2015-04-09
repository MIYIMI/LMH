//
//  LMH_GuideViewController.h
//  LaMaHui
//
//  Created by work on 14-8-11.
//  Copyright (c) 2014年 LYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseViewController.h"

typedef void (^ButtonBlock)(UIButton *button);

@interface LMH_GuideViewController : FTBaseViewController<UIScrollViewDelegate>
{
    ButtonBlock _buttonBlock;
    NSInteger _currentPageIndex;
}

- (void)setButtonBlock:(ButtonBlock)block;
//- (void)startScrolling;
@end