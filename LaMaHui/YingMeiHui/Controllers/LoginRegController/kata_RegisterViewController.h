//
//  kata_RegisterViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_TextField.h"

@protocol kata_RegisterViewControllerDelegate;

@interface kata_RegisterViewController : FTBaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) id<kata_RegisterViewControllerDelegate> regViewDelegate;

@end

@protocol kata_RegisterViewControllerDelegate <NSObject>

- (void)registerSuccessPop:(NSString *)username;

@end
