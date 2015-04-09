
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  SSCheckBoxView.m
//  SSCheckBoxView
//
//  Created by Ahmet Ardal on 12/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSCheckBoxView.h"
#import "UIHelpers.h"

#define UNCHECKEDLBLCOLOR       [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1]
#define CHECKEDLBLCOLOR         [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1]

static const CGFloat kHeight = 31.0f;

@interface SSCheckBoxView(Private)
- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s
                            checked:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) updateCheckBoxImage;
@end

@implementation SSCheckBoxView

@synthesize style, checked;

- (id) initWithFrame:(CGRect)frame
               style:(SSCheckBoxViewStyle)aStyle
             checked:(BOOL)aChecked
{
    frame.size.height = kHeight;
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }

    stateChangedSelector = nil;
    delegate = nil;
    style = aStyle;
    checked = aChecked;
    _textColorChange = YES;

    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];

    CGRect labelFrame = CGRectMake(34.0f, 9.0f, self.frame.size.width , 17.0f);
    UILabel *l = [[UILabel alloc] initWithFrame:labelFrame];
    l.textAlignment = NSTextAlignmentLeft;
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont boldSystemFontOfSize:14.0];
//    l.textColor = UNCHECKEDLBLCOLOR;
    l.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    l.shadowColor = [UIColor whiteColor];
//    l.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:l];
    textLabel = l;

    UIImage *img = [self checkBoxImageForStyle:style checked:checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
    iv.image = img;
    [self addSubview:iv];
    checkBoxImageView = iv;

    return self;
}

- (void) dealloc
{
    [checkBoxImageView release];
    [textLabel release];
    [super dealloc];
}

- (void) setText:(NSString *)text
{
    textLabel.font = [UIFont systemFontOfSize:18.0];
    [textLabel setText:text];
}

- (void) setChecked:(BOOL)isChecked
{
    checked = isChecked;
    [self updateCheckBoxImage];
    if (_textColorChange) {
        [self updateTextLabelColor];
    }
}

- (void) setStateChangedTarget:(id<NSObject>)target
                      selector:(SEL)selector
{
    delegate = target;
    stateChangedSelector = selector;
}


#pragma -
#pragma Touch related Methods

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    self.alpha = 0.8f;
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches
                withEvent:(UIEvent *)event
{
    self.alpha = 1.0f;
    [super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    // restore alpha
    self.alpha = 1.0f;

    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),
                                           (self.frame.origin.y - 10),
                                           (self.frame.size.width + 5),
                                           (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            checked = !checked;
            [self updateCheckBoxImage];
            if (_textColorChange) {
                [self updateTextLabelColor];
            }
            if (delegate && stateChangedSelector) {
                [delegate performSelector:stateChangedSelector
                               withObject:self];
            }
        }
    }

    [super touchesEnded:touches withEvent:event];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}


#pragma -
#pragma Private Methods

- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s
                            checked:(BOOL)isChecked
{
    NSString *suffix = isChecked ? @"on" : @"off";
    NSString *imageName = @"";
    switch (s) {
        case kSSCheckBoxViewStyleBox:
            imageName = @"cb_box_";
            break;
        case kSSCheckBoxViewStyleDark:
            imageName = @"cb_dark_";
            break;
        case kSSCheckBoxViewStyleGlossy:
            imageName = @"cb_glossy_";
            break;
        case kSSCheckBoxViewStyleGreen:
            imageName = @"cb_green_";
            break;
        case kSSCheckBoxViewStyleMono:
            imageName = @"cb_mono_";
            break;
        case kSSCheckBoxViewStyleCustom:
            imageName = @"cb_custom_";
            break;
        case kSSCheckBoxViewStyleCustom2:
            imageName = @"cb_custom2_";
            break;
        case kSSCheckBoxViewStyleCustom3:
            imageName = @"cb_custom3_";
            break;
        case kSSCheckBoxViewStyleCustom4:
            imageName = @"cb_custom4_";
            break;
        default:
            return nil;
    }
    imageName = [NSString stringWithFormat:@"%@%@", imageName, suffix];
    return [UIImage imageNamed:imageName];
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    //CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    CGFloat y = 10;
    return CGRectMake(8.0f, y, img.size.width, img.size.height);
}

- (void)updateCheckBoxImage
{
    checkBoxImageView.image = [self checkBoxImageForStyle:style
                                                  checked:checked];
}

- (void)updateTextLabelColor
{
    textLabel.textColor = checked ? CHECKEDLBLCOLOR : UNCHECKEDLBLCOLOR;
    textLabel.textColor = [UIColor blackColor];
}

@end
