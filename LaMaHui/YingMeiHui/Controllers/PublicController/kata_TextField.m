//
//  kata_TextField.m
//  YingMeiHui
//
//  Created by work on 14-12-6.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "kata_TextField.h"

@implementation kata_TextField

//禁止textField和textView的复制粘贴菜单：
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
