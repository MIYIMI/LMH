//
//  LMH_KeyBoradView.h
//  YingMeiHui
//
//  Created by work on 15/5/28.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMH_KeyBoradViewDelegate <NSObject>

- (void)keySendSms:(NSString *)smsInfo;
- (void)keyHeight:(CGFloat)height;

@end

@interface LMH_KeyBoradView : UIView

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)id <LMH_KeyBoradViewDelegate>keyDelegate;

@end
