//
//  kata_WalletPwdViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_LoginViewController.h"

@protocol kata_WalletPwdViewControllerDelegate;

@interface kata_WalletPwdViewController : FTBaseViewController <UITextFieldDelegate, LoginDelegate>

@property (assign, nonatomic) id<kata_WalletPwdViewControllerDelegate> pwdViewDelegate;

- (id)initWithCheckCode:(NSString *)code;
- (id)initWithCheckCode:(NSString *)code
            andUserName:(NSString *)username;

@end

@protocol kata_WalletPwdViewControllerDelegate <NSObject>

- (void)pwdSetSuccess;

@end
