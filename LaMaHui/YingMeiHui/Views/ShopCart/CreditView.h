//
//  CreditView.h
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditVO.h"
#import "MBProgressHUD.h"

@class CreditView;
@protocol CreditViewDelegate
- (void) btnClick:(NSInteger)credit_Num;
@end

@interface CreditView : UIView<UITextFieldDelegate, MBProgressHUDDelegate>
{
    UITextField *creditField;
    MBProgressHUD *stateHud;
    CreditVO *_creditVO;
    NSInteger _credit;
}

-(id)initWithFrame:(CGRect)frame andCredit:(NSInteger)credit;
@property (nonatomic, assign) id <CreditViewDelegate> delegate;
@end
