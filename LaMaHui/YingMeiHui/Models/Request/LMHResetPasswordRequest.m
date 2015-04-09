//
//  LMHResetPasswordRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-24.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHResetPasswordRequest.h"

@implementation LMHResetPasswordRequest

- (id)initWithcode:(NSString *)code
            mobile:(NSString *)mobile
           new_pwd:(NSString *)new_pwd
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        
        if (code) {
            [subParams setObject:code forKey:@"code"];
        }
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
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
    return @"reset_user_pwd";
}


@end
