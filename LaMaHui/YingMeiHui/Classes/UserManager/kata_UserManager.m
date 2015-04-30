//
//  kata_UserManager.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_UserManager.h"
#import "kata_FavManager.h"

#define ENCODE_KEY          @"YINGMEIHUI"

static kata_UserManager *__sharedUserManager;
static NSString *const __kUserInfoFileName = @"B911B8BD1AAD76D0";
static NSString *const __kPasswordInfoFileName = @"C2AC0692D60AAC29";

@interface kata_UserManager (/* 私有方法 */)

- (NSString *)userFileFullPath;
- (NSString *)pswFileFullPath;
- (NSData *)simpleEncode:(NSString *)s;
- (NSString *)simpleDecode:(NSData *)s;

@end

@implementation kata_UserManager

+ (kata_UserManager *)sharedUserManager
{
    if (!__sharedUserManager) {
        __sharedUserManager = [[kata_UserManager alloc] init];
    }
    
    return __sharedUserManager;
}

- (BOOL)isLogin
{
    NSDictionary *info = [self userInfo];
    
    if ([info objectForKey:@"user_id"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isRememberPsw
{
    NSDictionary *info = [self userInfo];
    
    if (info && [[info objectForKey:@"rememberPsw"] isEqualToString:@"true"]) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)userInfo
{
    NSString *path = [self userFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info.allKeys count] > 0) {
            return info;
        }
    }
    
    return nil;
}

- (BOOL)updateUserInfo:(NSDictionary *)userData
{
    NSString *path = [self userFileFullPath];
    
    return [NSKeyedArchiver archiveRootObject:userData toFile:path];
}

- (NSString *)userFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kUserInfoFileName];
    
    return fullPath;
}

- (NSString *)pswFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kPasswordInfoFileName];
    
    return fullPath;
}

- (BOOL)logout
{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
    
    [userDict removeObjectForKey:@"user_id"];
    [userDict removeObjectForKey:@"user_token"];
    [userDict removeObjectForKey:@"waitPayNum"];
    [[kata_FavManager sharedFavManager] cleanFav];
    
    [self updateUserInfo:userDict];
    
    return YES;
}

#pragma mark - Save and Get Password
- (BOOL)savePsw:(NSString *)psw
{
    NSString *path = [self pswFileFullPath];
    
    //    Clear Saved Password
    if (!psw || [psw isEqualToString:@""]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        return [fm removeItemAtPath:path error:nil];
    }
    NSData *pswArchivered = [self simpleEncode:psw];
    
    return [NSKeyedArchiver archiveRootObject:pswArchivered toFile:path];
}

- (NSString *)getPsw
{
    NSString *path = [self pswFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSData *psw = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (psw && [psw length] > 0) {
            return [self simpleDecode:psw];
        }
    }
    
    return nil;
}

- (void)updateWaitPayCnt:(NSNumber *)number{
    if (number) {
        NSMutableDictionary *userInfoDict  = [NSMutableDictionary dictionaryWithDictionary:[self userInfo]];
        NSInteger WaitPayNum = [number intValue];
        [userInfoDict setObject:[NSString stringWithFormat:@"%zi",WaitPayNum] forKey:@"waitPayNum"];
        [[kata_UserManager sharedUserManager] updateUserInfo:userInfoDict];
        
    }
}
- (NSNumber *)userWaitPayCnt{
    NSDictionary *dict = [self userInfo];
    NSInteger value = [[dict objectForKey:@"waitPayNum"] intValue];
    NSNumber *tempNumber = [NSNumber numberWithInteger:value];
    return tempNumber;
}

#pragma mark - Encode and Decode
- (NSData *)simpleEncode:(NSString *)s
{
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    char *dataPtr = (char *)[data bytes];
    char *keyData = (char *)[[ENCODE_KEY dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    NSInteger keyIndex = 0;
    
    for (NSInteger i = 0; i < [data length]; i++) {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [ENCODE_KEY length]) {
            keyIndex = 0;
            keyPtr = keyData;
        }
    }
    
    return data;
}

- (NSString *)simpleDecode:(NSData *)s
{
    NSData *data = [NSData dataWithData:s];
    
    char *dataPtr = (char *)[data bytes];
    char *keyData = (char *)[[ENCODE_KEY dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    NSInteger keyIndex =0;
    
    for (NSInteger i = 0; i < [data length]; i++) {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [ENCODE_KEY length]) {
            keyIndex = 0;
            keyPtr = keyData;
        }
    }
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

//缓存方法
- (BOOL)updateHomeData:(NSDictionary *)homeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedHomeData = [NSKeyedArchiver archivedDataWithRootObject:homeData];
    [defaults setObject:encodedHomeData forKey:[NSString stringWithFormat:@"home_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [defaults synchronize];
    
    return YES;
}

- (NSDictionary *)getHomeData{
    NSData* data  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"home_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (BOOL)updateMenuData:(NSDictionary *)menuData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedMenuData = [NSKeyedArchiver archivedDataWithRootObject:menuData];
    [defaults setObject:encodedMenuData forKey:[NSString stringWithFormat:@"menu_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [defaults synchronize];
    
    return YES;
}
- (NSDictionary *)getMenuData{
    NSData* data  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"menu_%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
