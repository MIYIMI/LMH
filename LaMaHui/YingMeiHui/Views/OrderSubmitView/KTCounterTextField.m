//
//  KTCounterTextField.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-12.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCounterTextField.h"
#import "BOKUNoActionTextField.h"

#define NUMBERSSS               @"1234567890"

@interface KTCounterTextField ()
{
    UIButton *_minusBtn;
    UIButton *_addBtn;
    BOKUNoActionTextField *_countTF;
}

@end

@implementation KTCounterTextField

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 109, 30)];
    if (self) {
        [self createView];
        self.counter = [NSNumber numberWithInteger:1];
    }
    return self;
}

- (void)createView
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"counterminusbtn"] forState:UIControlStateNormal];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"counterminusbtn_selected"] forState:UIControlStateHighlighted];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"counterminusbtn_selected"] forState:UIControlStateSelected];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"counterminusbtn_disable"] forState:UIControlStateDisabled];
        [_minusBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [_minusBtn addTarget:self action:@selector(minusBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [_minusBtn setEnabled:NO];
    [self addSubview:_minusBtn];
    
    if (!_countTF) {
        _countTF = [[BOKUNoActionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minusBtn.frame) + 2, 0, 45, 30)];
        [_countTF setBackgroundColor:[UIColor whiteColor]];
        [_countTF setTextColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.41 alpha:1]];
        [_countTF setTextAlignment:NSTextAlignmentCenter];
        [_countTF setFont:[UIFont systemFontOfSize:12.0]];
        [_countTF setText:@"1"];
        [_countTF setKeyboardType:UIKeyboardTypeNumberPad];
        [_countTF setDelegate:self];
        [_countTF.layer setBorderWidth:0.5];
        [_countTF.layer setBorderColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1].CGColor];
    }
    [self addSubview:_countTF];
    
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"counteraddbtn"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"counteraddbtn_selected"] forState:UIControlStateHighlighted];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"counteraddbtn_selected"] forState:UIControlStateSelected];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"counteraddbtn_disable"] forState:UIControlStateDisabled];
        [_addBtn setFrame:CGRectMake(CGRectGetMaxX(_countTF.frame) + 2, 0, 30, 30)];
        [_addBtn addTarget:self action:@selector(addBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:_addBtn];
}

- (void)minusBtnPressed
{
    self.counter = [NSNumber numberWithInteger:[_counter integerValue] - 1];
}

- (void)addBtnPressed
{
    self.counter = [NSNumber numberWithInteger:[_counter integerValue] + 1];
}

- (void)setCounter:(NSNumber *)counter
{
    _counter = counter;
    if (_counter) {
        _countTF.text = [_counter stringValue];
        
        if ([_counter integerValue] <= 1) {
            [_minusBtn setEnabled:NO];
            [_addBtn setEnabled:YES];
        } else if ([_counter integerValue] >= 999) {
            [_minusBtn setEnabled:YES];
            [_addBtn setEnabled:NO];
        } else {
            [_minusBtn setEnabled:YES];
            [_addBtn setEnabled:YES];
        }
        
        if (self.counterTFDelegate && [self.counterTFDelegate respondsToSelector:@selector(cntChanged:)]) {
            [self.counterTFDelegate cntChanged:[_counter intValue]];
        }
    }
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(strlen([textField.text UTF8String]) >= 3 && range.length != 1) {
        return NO;
    } else {
        if (strlen([string UTF8String]) <= 3) {
            NSCharacterSet *cs;
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSSS] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL canChange = [string isEqualToString:filtered];
            
            return canChange;
        } else {
            return NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text && [textField.text isEqualToString:@""]) {
        textField.text = @"1";
    }
    if (textField.text && [textField.text intValue] == 0) {
        textField.text = @"1";
    }
    _counter = [NSNumber numberWithInteger:[textField.text integerValue]];
    
    if ([_counter integerValue] <= 1) {
        [_minusBtn setEnabled:NO];
        [_addBtn setEnabled:YES];
    } else if ([_counter integerValue] >= 999) {
        [_minusBtn setEnabled:YES];
        [_addBtn setEnabled:NO];
    } else {
        [_minusBtn setEnabled:YES];
        [_addBtn setEnabled:YES];
    }
    
    if (self.counterTFDelegate && [self.counterTFDelegate respondsToSelector:@selector(cntChanged:)]) {
        [self.counterTFDelegate cntChanged:[_counter intValue]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.counterTFDelegate && [self.counterTFDelegate respondsToSelector:@selector(cntTFBeginEditting:)]) {
        [self.counterTFDelegate cntTFBeginEditting:textField];
    }
    return YES;
}

@end
