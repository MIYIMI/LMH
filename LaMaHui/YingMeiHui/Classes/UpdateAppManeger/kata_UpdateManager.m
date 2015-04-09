//
//  kata_UpdateManager.m
//  YingMeiHui
//
//  Created by work on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_UpdateManager.h"
#import "KTUpdateAppRequest.h"
#import "KTProxy.h"

static kata_UpdateManager *__sharedUpdateManager;

//#define URL @"EnterpriseUrl" //企业url
#define URL @"AppStoreUrl" //appstore url

@implementation kata_UpdateManager
{
    BOOL updateForce;//0表示强制升级  1表示选择升级
    NSString *version;
    NSString *appUrl;
}

@synthesize updateDelegate;

+ (kata_UpdateManager *)sharedUpdateManager
{
    if (!__sharedUpdateManager) {
        __sharedUpdateManager = [[kata_UpdateManager alloc] init];
    }
    
    return __sharedUpdateManager;
}

#pragma mark - KTUpdateAppRequest
- (void)updateApp
{
    KTUpdateAppRequest *req = [[KTUpdateAppRequest alloc]
                               initWithNone];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(updateAppResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self.updateDelegate updateAppResult:UpdateStateNO];
        //载入失败处理 载入失败界面
    }];
    
    [proxy start];
}

//app更新接口数据解析
- (void)updateAppResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([[respDict objectForKey:@"code"] integerValue] == 0) {
                if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *appDict = (NSDictionary *)[respDict objectForKey:@"data"];
                    
                    [self updateAppsuccess:appDict];
                }
                else {
                    //载入失败处理 载入失败界面
                    [self.updateDelegate updateAppResult:UpdateStateNO];
                }
            } else {
                //载入失败处理 载入失败界面
                [self.updateDelegate updateAppResult:UpdateStateNO];
            }
        } else {
            //载入失败处理 载入失败界面 输出message
            [self.updateDelegate updateAppResult:UpdateStateNO];
        }
    }else{
        [self.updateDelegate updateAppResult:UpdateStateNO];
    }
}

//app更新
-(void)updateAppsuccess:(NSDictionary *)appInfo{
    if (!appInfo) {
        [self.updateDelegate updateAppResult:UpdateStateNO];
        return;
    }
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    //是否强制更新
    if (nil != [appInfo objectForKey:@"type"] && ![[appInfo objectForKey:@"type"] isEqual:[NSNull null]]) {
        updateForce = [[appInfo objectForKey:@"type"] boolValue];
    }
    
    //服务器版本号
    if (nil != [appInfo objectForKey:@"version"] && ![[appInfo objectForKey:@"version"] isEqual:[NSNull null]]) {
        version = [appInfo objectForKey:@"version"];
    }
    
    //app的地址
    if (nil != [appInfo objectForKey:URL] && ![[appInfo objectForKey:URL] isEqual:[NSNull null]]) {
        appUrl = [appInfo objectForKey:URL];
    }
    UIAlertView* alert;
    if (([version compare:myVersion options:NSNumericSearch] == NSOrderedDescending) && appUrl) {
        if (!updateForce) {
            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"版本有升级，请升级后使用！" delegate:self cancelButtonTitle:@"去升级" otherButtonTitles:nil];
            [alert show];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本有升级，请升级后使用" delegate:self cancelButtonTitle:@"残忍的拒绝" otherButtonTitles:@"快乐的升级", nil];
            [alert show];
        }
    }else{
        [self.updateDelegate updateAppResult:UpdateStateYES];
    }
}

//跳转更新
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1 && updateForce && appUrl){
        NSURL *url = [NSURL URLWithString:appUrl];
        [[UIApplication sharedApplication]openURL:url];
        assert(0);
    }else if(buttonIndex==1 && appUrl){
        [self.updateDelegate updateAppResult:UpdateStateYES];
    }else{
        [self.updateDelegate updateAppResult:UpdateStateIGNORE];
    }
}

@end
