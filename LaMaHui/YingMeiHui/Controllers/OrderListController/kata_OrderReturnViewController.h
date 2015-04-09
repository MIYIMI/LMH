//
//  kata_OrderReturnViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_LoginViewController.h"

@protocol kata_OrderReturnViewControllerDelegate;

@interface kata_OrderReturnViewController : FTBaseViewController
<
UITextFieldDelegate,
LoginDelegate,
UITextViewDelegate,
UIAlertViewDelegate
>

@property (assign, nonatomic) id<kata_OrderReturnViewControllerDelegate> rtnViewDelegate;

- (id)initWithOrderID:(NSString *)orderid;

@end

@protocol kata_OrderReturnViewControllerDelegate <NSObject>

- (void)returnSuccess;

@end
