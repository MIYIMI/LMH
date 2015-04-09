//
//  LMHUIManager.m
//  YingMeiHui
//
//  Created by KevinKong on 14-8-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LMHUIManager.h"
#import "LMH_GeXinAPNSTool.h"
#import "kata_CategoryViewController.h"
#import "kata_LoginViewController.h"

@implementation LMHUIManager

static LMHUIManager *lmhuimanager = nil;

+(LMHUIManager *)sharedUIManager{
    @synchronized (self)
    {
        if (lmhuimanager == nil)
        {
            lmhuimanager = [[self alloc] init];
        }
    }
    return lmhuimanager;
}
+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (lmhuimanager == nil) {
            lmhuimanager = [super allocWithZone:zone];
            return lmhuimanager;
        }
    }
    return nil;
}
- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

#pragma mark -
#pragma mark public methods
-(kata_AppDelegate *)getAppDelegate{
    return (kata_AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(kata_CategoryViewController *)getRootVC{
    return [self getAppDelegate].rootVC;
}

-(UIViewController *)getCurrentDisplayViewController{
    kata_CategoryViewController *rootVC = [self getRootVC];
   return  [rootVC.navigationController.childViewControllers lastObject];
}

- (void)skipVC:(AdvVO *)advo{
    [[self getRootVC] nextView:advo];
}

@end
