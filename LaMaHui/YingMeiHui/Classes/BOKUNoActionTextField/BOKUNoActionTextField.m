//
//  BOKUNoActionTextField.m
//  BokuApp
//
//  Created by 林 程宇 on 13-12-1.
//  Copyright (c) 2013年 boku. All rights reserved.
//

#import "BOKUNoActionTextField.h"

@implementation BOKUNoActionTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
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
