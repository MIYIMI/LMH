//
//  KTBaseRequest.m
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"
#import "NSString+KTStringHelper.h"
#import "KATACheckUtils.h"
#import "UIDevice+Resolutions.h"
#import <AFNetworking/AFNetworking.h>

#define CHANNEL @"1200"

@interface KTBaseRequest ()

- (NSData *)toJSONData:(id)theData;

@end

@implementation KTBaseRequest

@synthesize params = _params;

- (id)initWithNone
{
    if (self = [super init]) {
        [self params];
    }
    
    return self;
}

- (NSString *)method
{
    return nil;
}

- (NSDictionary *)query
{
    NSString *appkeyStr = APP_KEY;
    if (appkeyStr) {
        [_params setObject:appkeyStr forKey:@"app_key"];
    }
    
    NSString *methodStr = [self method];
    if (methodStr) {
        [_params setObject:methodStr forKey:@"method"];
    }else{
        methodStr =[_params objectForKey:@"method"];
    }
    
    NSString *timestampStr = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if (timestampStr) {
        [_params setObject:timestampStr forKey:@"timestamp"];
    }
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@", appkeyStr, methodStr, timestampStr, APP_SECRET].md5;
    if (signStr) {
        [_params setObject:signStr forKey:@"app_sign"];
    }
    
    if (APP_NAME) {
        [_params setObject:APP_NAME forKey:@"app_name"];
    }
    
    if (CLIENT_NAME) {
        [_params setObject:CLIENT_NAME forKey:@"client"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cid"]) {
        [_params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"cid"] forKey:@"cid"];
    }
    
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]) {
        [_params setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"app_version"];
    }
    
    if ([OpenUDID value]) {
        [_params setObject:[OpenUDID value] forKey:@"device_id"];
    }
    
    [_params setObject:CHANNEL forKey:@"ditch_number"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDef objectForKey:@"user_uuid"];
    
    if (value) {
        [_params setObject:value forKey:@"user_uuid"];
    }else{
        [_params setObject:@"0" forKey:@"user_uuid"];
    }
    
    [_params setObject:[[DeviceModel shareModel] netType] forKey:@"net"];
    [_params setObject:[[DeviceModel shareModel] deviceType] forKey:@"mobile_brand"];
    [_params setObject:[[DeviceModel shareModel] phoneType] forKey:@"mobile_model"];
    [_params setObject:[[DeviceModel shareModel] carrierName] forKey:@"mobile_operator"];
    [_params setObject:[[DeviceModel shareModel] systemOS] forKey:@"system_version"];
    [_params setObject:[[DeviceModel shareModel] scrResolution] forKey:@"screen_size"];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [_params setObject:[def objectForKey:@"cv"]?[def objectForKey:@"cv"]:@1 forKey:@"cv"];
    
    if (nil != [_params objectForKey:@"params"] && ![[_params objectForKey:@"params"] isEqual:[NSNull null]]) {
        id paramsData = [_params objectForKey:@"params"];
        
        if ([paramsData isKindOfClass:[NSDictionary class]]) {
            NSString *paramsJsonString = [[NSString alloc] initWithData:[self toJSONData:paramsData]
                                                               encoding:NSUTF8StringEncoding];
            
            [_params setObject:paramsJsonString forKey:@"params"];
        } else {
            [_params removeObjectForKey:@"params"];
        }
    } else {
        [_params removeObjectForKey:@"params"];
    }
    
    return _params;
}

- (BOOL)isPrivate
{
    return NO;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    
    return _params;
}

- (NSData *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end
