//
//  kata_LoginViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_RegisterViewController.h"
//#import <TencentOpenAPI/TencentOAuth.h>
#import <AFNetworking/AFNetworking.h>
#import "kata_TextField.h"

@protocol LoginDelegate <NSObject>

- (void)didLogin;
- (void)loginCancel;

@optional
- (void)loginViewPresented;
- (void)loginViewDismissed;

@end

@interface kata_LoginViewController : FTBaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, kata_RegisterViewControllerDelegate>

@property (assign, nonatomic) id<LoginDelegate> loginDelegate;

+ (void)showInViewController:(id<LoginDelegate>)mainVC;
- (void)showLoginBoardWithAnimated:(BOOL)animated;

@end
