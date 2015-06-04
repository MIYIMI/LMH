//
//  kata_WebViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTBaseViewController.h"

#import "kata_UserManager.h"
#import "NJKScrollFullScreen.h"

@interface kata_WebViewController : FTBaseViewController <UIWebViewDelegate,NJKScrollFullscreenDelegate>

@property(nonatomic,strong)NSString *userID;

- (id)initWithUrl:(NSString *)url title:(NSString *)title andType:(NSString *)type;

@end
