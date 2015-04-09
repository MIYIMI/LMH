//
//  kata_UserManager.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kata_UserManager : NSObject

+ (kata_UserManager *)sharedUserManager;

- (BOOL)isLogin;
- (BOOL)isRememberPsw;
- (NSDictionary *)userInfo;
- (BOOL)updateUserInfo:(NSDictionary *)userData;
- (BOOL)logout;
- (BOOL)savePsw:(NSString *)psw;
- (NSString *)getPsw;

- (void)updateWaitPayCnt:(NSNumber *)number;
- (NSNumber *)userWaitPayCnt;

- (BOOL)updateHomeData:(NSDictionary *)homeData;
- (NSDictionary *)getHomeData;

- (BOOL)updateMenuData:(NSDictionary *)menuData;
- (NSDictionary *)getMenuData;
@end
