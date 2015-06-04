//
//  LMH_GeXinAPNSTool.m
//  YingMeiHui
//
//  Created by KevinKong on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LMH_GeXinAPNSTool.h"
#import "WCAlertView.h"
#import "LimitedSeckillViewController.h"

@interface LMH_GeXinAPNSTool()
{
    UIApplicationState applicationState;
    AdvVO *_adv;
}
@end

@implementation LMH_GeXinAPNSTool
@synthesize gexinPusher = _gexinPusher;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appID = _appID;
@synthesize clientId = _clientId;
@synthesize sdkStatus = _sdkStatus;
@synthesize lastPayloadIndex = _lastPaylodIndex;
@synthesize payloadId = _payloadId;

static LMH_GeXinAPNSTool *gexinApnsTool = nil;

+(LMH_GeXinAPNSTool *)sharedAPNSTool{
    @synchronized (self)
    {
        if (gexinApnsTool == nil)
        {
           gexinApnsTool = [[self alloc] init];
        }
    }
    return gexinApnsTool;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (gexinApnsTool == nil) {
            gexinApnsTool = [super allocWithZone:zone];
            return gexinApnsTool;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (void)setApplicationState:(UIApplicationState )_applicationState{
    applicationState = _applicationState;
}

- (UIApplicationState )getApnsApplicationState{
    return applicationState;
}

- (void)registerRemoteNotification
{
    LMHLog(" register remote notification ");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        //这里还是原来的代码
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:self.appID
                                             appKey:self.appKey
                                          appSecret:self.appSecret
                                         appVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            //[_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
            LMHLog(" GeXinSdk %@",[NSString stringWithFormat:@"%@", [err localizedDescription]]);
        } else {
            _sdkStatus = SdkStatusStarting;
        }
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
        
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = clientId ;
    LMHLog(" clientid = %@",clientId);
    [[NSUserDefaults standardUserDefaults] setObject:_clientId forKey:@"cid"];
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    _payloadId = payloadId;
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
    if (payloadMsg.length > 0) {
        NSData *respData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        _adv = [AdvVO AdvVOWithDictionary:respDict];
    }

    if (applicationState == UIApplicationStateActive) {
        
    }else if(_adv){
        LMHLog(@" UIApplicationStateInactive| or background");
        [[LMHUIManager sharedUIManager] performSelector:@selector(skipVC:) withObject:_adv afterDelay:0];
    }
}

- (void)pushVC{
    //秒杀本地通知
    NSNumber *def = [[NSUserDefaults standardUserDefaults] objectForKey:@"seckill"];
    
    AdvVO *adv = [[AdvVO alloc] init];
    if ([def boolValue]) {
        adv.Type = @101;
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"seckill"];
    }
    UIViewController *currentViewController = [[LMHUIManager sharedUIManager] getCurrentDisplayViewController];
    if([currentViewController isKindOfClass:[LimitedSeckillViewController class]]){
        return;
    }
    [[LMHUIManager sharedUIManager] performSelector:@selector(skipVC:) withObject:adv afterDelay:1];
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    LMHLog(" GeXin SDK  did OccurError %@",error);
}
@end
