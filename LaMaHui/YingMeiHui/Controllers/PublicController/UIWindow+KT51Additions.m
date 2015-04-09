//
//  UIWindow+KT51Additions.m
//  Kata51SDK
//
//  Created by hark2046 on 14-1-18.
//  Copyright (c) 2014年 KATA. All rights reserved.
//

#import "UIWindow+KT51Additions.h"

BOOL KTIsKeyboardVisible()
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    return !![window findFirstResponder];
}

@implementation UIWindow (KT51Additions)

- (UIView *)findFirstResponder
{
    return [self findFirstResponderInView:self];
}

- (UIView *)findFirstResponderInView:(UIView *)topView
{
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView * subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView *firstResponderCheck = [self findFirstResponderInView:subView];
        
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

@end
