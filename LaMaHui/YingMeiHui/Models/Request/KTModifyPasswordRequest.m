//
//  KTModifyPasswordRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTModifyPasswordRequest.h"

@implementation KTModifyPasswordRequest

- (id)initWithBindUsername:(NSString *)username
                 andUserID:(long)userid
              andUserToken:(NSString *)token
                   andCode:(NSString *)code
            andNewLoginPwd:(NSString *)newLoginPwd
            andOldLoginPwd:(NSString *)oldLoginPwd
              andNewPayPwd:(NSString *)newPayPwd
              andOldPayPwd:(NSString *)oldPayPwd
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:8];
        if (username) {
            [subParams setObject:username forKey:@"username"];
        }
        
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (code) {
            [subParams setObject:code forKey:@"code"];
        }
        
        if (newLoginPwd) {
            [subParams setObject:newLoginPwd forKey:@"new_login_password"];
        }
        
        if (oldLoginPwd) {
            [subParams setObject:oldLoginPwd forKey:@"old_login_password"];
        }
        
        if (newPayPwd) {
            [subParams setObject:newPayPwd forKey:@"new_pay_password"];
        }
        
        if (oldPayPwd) {
            [subParams setObject:oldPayPwd forKey:@"old_pay_password"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"modify_password_request";
}

@end
