//
//  BOKUBannerImageButton.m
//  BokuApp
//
//  Created by 林 程宇 on 13-12-3.
//  Copyright (c) 2013年 boku. All rights reserved.
//

#import "BOKUBannerImageButton.h"

@implementation BOKUBannerImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSlider:(AdvVO *)slider
{
    _slider = slider;
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
