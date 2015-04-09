//
//  kata_InputPayPwdViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_LoginViewController.h"

@interface kata_InputPayPwdViewController : FTBaseViewController <UITextFieldDelegate, LoginDelegate, UIActionSheetDelegate>

- (id)initWithOrderID:(NSString *)orderid
             andTotal:(CGFloat)total;

@end
