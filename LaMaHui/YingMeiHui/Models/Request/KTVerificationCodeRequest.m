//
//  KTVerificationCodeRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTVerificationCodeRequest.h"

@implementation KTVerificationCodeRequest

- (id)initWithBindUserID:(long)userid
            andUserToken:(NSString *)token
               andMobile:(NSString *)mobile
                 andType:(NSInteger)type
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
        }
        
        if (type != -1) {
            [subParams setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (id)initWithFindUsername:(NSString *)username
                 andMobile:(NSString *)mobile
                   andType:(NSInteger)type
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (username) {
            [subParams setObject:username forKey:@"username"];
        }
        
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
        }
        
        if (type != -1) {
            [subParams setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"verification_code_request";
}

@end
