//
//  KTPropButton.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-10.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTPropButton.h"

@interface KTPropButton ()
{
    
}

@end

@implementation KTPropButton

@synthesize colorData;
@synthesize sizeData;

- (id)initWithFrame:(CGRect)frame
            andName:(NSString *)name
          withStock:(NSInteger)stock
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self setTitle:name forState:UIControlStateNormal];
        
        if (stock != 0) {
            self.buttonState = KTPropButtonNormal;
            self.enabled = YES;
        } else {
            self.buttonState = KTPropButtonNoStock;
            self.enabled = NO;
        }
    }
    return self;
}

- (void)setButtonState:(KTPropButtonState)buttonState
{
    _buttonState = buttonState;
    
    switch (_buttonState) {
        case KTPropButtonNoStock:
        {
            UIImage *image = [UIImage imageNamed:@"propbtnnostock"];
            image = [image stretchableImageWithLeftCapWidth:12.0f topCapHeight:11.0f];
            [self setBackgroundImage:image forState:UIControlStateNormal];
            
            [self setTitleColor:LMH_COLOR_LIGHTGRAY forState:UIControlStateNormal];
            self.enabled = NO;
        }
            break;
            
        case KTPropButtonNormal:
        {
            UIImage *image = [UIImage imageNamed:@"propbtnnormal"];
            image = [image stretchableImageWithLeftCapWidth:12.0f topCapHeight:11.0f];
            [self setBackgroundImage:image forState:UIControlStateNormal];
            
            [self setTitleColor:LMH_COLOR_BLACK forState:UIControlStateNormal];
            self.enabled = YES;
        }
            break;
            
        case KTPropButtonSelected:
        {
            UIImage *image = [UIImage imageNamed:@"propbtnselected"];
            image = [image stretchableImageWithLeftCapWidth:12.0f topCapHeight:11.0f];
            [self setBackgroundImage:image forState:UIControlStateNormal];
            
            [self setTitleColor:LMH_COLOR_SKIN forState:UIControlStateNormal];
            self.enabled = NO;
        }
            break;
            
        default:
            break;
    }
}

@end
