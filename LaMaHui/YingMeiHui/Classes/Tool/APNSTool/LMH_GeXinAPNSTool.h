//
//  LMH_GeXinAPNSTool.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GexinSdk.h"
typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface LMH_GeXinAPNSTool : NSObject<GexinSdkDelegate>


@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) NSInteger lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;


+(LMH_GeXinAPNSTool *)sharedAPNSTool;

- (void)setApplicationState:(UIApplicationState )applicationState;
- (UIApplicationState )getApnsApplicationState;

- (void)registerRemoteNotification;
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)pushVC;

@end
