//
//  LMHChangePasswordRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-2.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHChangePasswordRequest.h"

@implementation LMHChangePasswordRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andold_pwd:(NSString *)old_pwd
          andnew_pwd:(NSString *)new_pwd
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (old_pwd) {
            [subParams setObject:old_pwd forKey:@"old_pwd"];
        }
        if (new_pwd) {
            [subParams setObject:new_pwd forKey:@"new_pwd"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"user_pwd_change";
}

@end
