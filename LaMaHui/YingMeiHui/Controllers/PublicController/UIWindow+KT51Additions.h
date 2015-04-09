//
//  UIWindow+KT51Additions.h
//  Kata51SDK
//
//  Created by hark2046 on 14-1-18.
//  Copyright (c) 2014年 KATA. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL KTIsKeyboardVisible();

@interface UIWindow (KT51Additions)

- (UIView *)findFirstResponder;

- (UIView *)findFirstResponderInView:(UIView *)topView;

@end
