//
//  kata_UpdateManager.h
//  YingMeiHui
//
//  Created by work on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

//app更新状态
typedef enum
{
    UpdateStateNO       = 0,    //网络出错
    UpdateStateIGNORE   = 1,    //忽略更新
    UpdateStateYES      = 2,    //确定更新
}UpdateState;

@protocol kata_UpdateManagerDelegate <NSObject>

-(void) updateAppResult:(UpdateState)State;

@end

@interface kata_UpdateManager : NSObject

+ (kata_UpdateManager *)sharedUpdateManager;
-(void)updateApp;

@property (assign, nonatomic) id<kata_UpdateManagerDelegate> updateDelegate;
@end
