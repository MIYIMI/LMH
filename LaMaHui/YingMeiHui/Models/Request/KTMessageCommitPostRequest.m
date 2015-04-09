//
//  KTMessageCommitPostRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTMessageCommitPostRequest.h"

@implementation KTMessageCommitPostRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
             Content:(NSString *)content
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (content) {
            [subParams setObject:content forKey:@"content"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"message_commit_post";
}

@end
