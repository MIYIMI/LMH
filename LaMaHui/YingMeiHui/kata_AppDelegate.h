//
//  kata_AppDelegate.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMH_GuideViewController.h"
#import "KTChannelViewController.h"
#import "KTMCenterTabVC.h"
#import "IIViewDeckController.h"
#import "LMH_Config.h"
#import "kata_CategoryViewController.h"

@interface kata_AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
@private
    NSString *_deviceToken;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) kata_CategoryViewController * rootVC;
@property (nonatomic, strong) IIViewDeckController* deckController;
//@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

@end
