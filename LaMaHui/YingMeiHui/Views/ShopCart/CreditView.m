//
//  CreditView.m
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CreditView.h"

@implementation CreditView

-(id)initWithFrame:(CGRect)frame andCredit:(NSInteger)credit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        _credit = credit;
        
        creditField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-100)/2, 23, 100, 30)];
        creditField.layer.masksToBounds = NO;
        creditField.layer.cornerRadius = 5;
        
        [creditField setText:[NSString stringWithFormat:@"%zi", credit]];
        creditField.keyboardType = UIKeyboardTypeNumberPad;
        creditField.delegate = self;
        [creditField setTextColor:[UIColor colorWithRed:0.98 green:0.3 blue:0.41 alpha:1]];
        [creditField setTextAlignment:NSTextAlignmentCenter];
        creditField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000] CGColor];
        creditField.layer.borderWidth = 1.0;
        [self addSubview:creditField];
        
        UILabel *beginLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(creditField.frame)-35, 25, 30, 30)];
        [beginLbl setText:@"使用"];
        [beginLbl setTextColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]];
        [beginLbl setFont:[UIFont systemFontOfSize:15.0]];
        [beginLbl setTextAlignment:NSTextAlignmentRight];
        [self addSubview:beginLbl];
        
        UILabel *endLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(creditField.frame)+5, 25, 30, 30)];
        [endLbl setText:@"金豆"];
        [endLbl setTextColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]];
        [endLbl setFont:[UIFont systemFontOfSize:15.0]];
        [endLbl setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:endLbl];
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2, CGRectGetHeight(self.frame) - 60, 80, 30)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"payback"] forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"payback"] forState:UIControlStateHighlighted];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"payback"] forState:UIControlStateSelected];
        [checkBtn setTitle:@"确定" forState:UIControlStateNormal];
        [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [checkBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [checkBtn addTarget:self action:@selector(creditClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkBtn];
    }
    return self;
}

-(void)creditClick
{
    NSInteger creditNum = [creditField.text floatValue];
    if (creditNum > _credit) {
        [self textStateHUD:[NSString stringWithFormat:@"对不起，您可使用金豆为%zi", _credit]];
        creditField.text = [NSString stringWithFormat:@"%zi", _credit];
        return;
    }

    [self.delegate btnClick:creditNum];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *view = [self superview];
    
    [view setFrame:CGRectMake(20, ScreenH - 256 - ScreenH / 4, CGRectGetWidth(view.frame), ScreenH / 4)];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UIView *view = [self superview];
    
    [view setFrame:CGRectMake(20, ScreenH/8*3, CGRectGetWidth(view.frame), ScreenH / 4)];
    return YES;
}

static bool flag = YES;
//点击textField隐藏键盘
- (UIView *)hitTest:(CGPoint)poNSInteger withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:poNSInteger withEvent:event];
    if (result != creditField && flag) {
        flag = NO;
        [creditField endEditing:YES];
        UIView *view = [self superview];
        [view setFrame:CGRectMake(20, ScreenH/8*3, CGRectGetWidth(view.frame), ScreenH / 4)];
    }else{
        flag = YES;
    }
    
    return result;
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self];
        stateHud.delegate = self;
        [self addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.5];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [stateHud removeFromSuperview];
    stateHud = nil;
}

@end
