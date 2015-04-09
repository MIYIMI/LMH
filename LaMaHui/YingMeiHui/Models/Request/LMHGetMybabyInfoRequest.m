//
//  LMHGetMybabyInfoRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-1.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHGetMybabyInfoRequest.h"

@implementation LMHGetMybabyInfoRequest


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
    return @"get_baby_info";
}

@end
