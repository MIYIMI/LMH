//
//  LMH_KeyBoradView.m
//  YingMeiHui
//
//  Created by work on 15/5/28.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_KeyBoradView.h"

@interface LMH_KeyBoradView()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *sendBtn;
    CGRect vFrame;
}

@end

@implementation LMH_KeyBoradView
@synthesize textField;
@synthesize nickName;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, ScreenW-60, 30)];
        textField.layer.cornerRadius = 3.0;
        textField.layer.borderColor = LMH_COLOR_LIGHTGRAY.CGColor;
        textField.layer.borderWidth = 0.5;
        textField.font = LMH_FONT_15;
        textField.textColor = LMH_COLOR_GRAY;
        textField.placeholder = nickName;
        [self addSubview:textField];
        
        sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-40, 5, 30, 30)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn.titleLabel setFont:LMH_FONT_15];
        sendBtn.layer.borderColor = LMH_COLOR_LIGHTLINE.CGColor;
        sendBtn.layer.borderWidth = 1.0;
        [sendBtn setTitleColor:LMH_COLOR_LIGHTbLUE forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
        vFrame = frame;
    }
    
    return self;
}

- (void)sendClick{
    NSLog(@"%@", textField.text);
    //过滤字符串前后的空格
    NSString *sendSms = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    sendSms = [sendSms stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (sendSms.length <= 0) {
        return;
    }
    if ([self.keyDelegate respondsToSelector:@selector(keySendSms:)]) {
        [self.keyDelegate keySendSms:textField.text];
    }
}

- (void) keyboardWasShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat hOffset = endKeyboardRect.size.height;
    CGFloat yOffset = endKeyboardRect.origin.y;
    
    CGRect frame = vFrame;
    if (yOffset == ScreenH) {
        self.frame = vFrame;
    }else{
        frame.origin.y = ScreenH - hOffset - 64 - 40;
        self.frame = frame;
    }
    
    if ([self.keyDelegate respondsToSelector:@selector(keyHeight:)]) {
        [self.keyDelegate keyHeight:hOffset];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
