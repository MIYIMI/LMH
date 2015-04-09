//
//  kata_FeedbackSubmitViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"
#import "kata_LoginViewController.h"

@protocol kata_FeedbackSubmitViewControllerDelegate <NSObject>

- (void)changeView:(NSString *)feeStr;

@end

@interface kata_FeedbackSubmitViewController : FTBaseViewController <LoginDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property(nonatomic,strong)id<kata_FeedbackSubmitViewControllerDelegate> delegate;

@end
