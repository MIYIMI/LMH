//
//  LMHUIManager.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kata_AppDelegate.h"
#import "kata_CategoryViewController.h"
#import "AdvVO.h"

@interface LMHUIManager : NSObject

+(LMHUIManager *)sharedUIManager;

-(kata_AppDelegate *)getAppDelegate;
-(kata_CategoryViewController *)getRootVC;
-(UIViewController *)getCurrentDisplayViewController;
- (void)skipVC:(AdvVO *)advo;

@end
