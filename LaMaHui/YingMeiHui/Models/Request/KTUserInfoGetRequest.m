//
//  KTUserInfoGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTUserInfoGetRequest.h"

@implementation KTUserInfoGetRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"userinfo_get";
}

@end
