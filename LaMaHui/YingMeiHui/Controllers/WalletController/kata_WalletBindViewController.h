//
//  kata_WalletBindViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_LoginViewController.h"
#import "kata_WalletPwdViewController.h"

@protocol kata_WalletBindViewControllerDelegate;

@interface kata_WalletBindViewController : FTBaseViewController <UITextFieldDelegate, LoginDelegate, kata_WalletPwdViewControllerDelegate>

@property (assign, nonatomic) id<kata_WalletBindViewControllerDelegate> bindViewDelegate;

@end

@protocol kata_WalletBindViewControllerDelegate <NSObject>

- (void)walletBindSuccess;

@end
