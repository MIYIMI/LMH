//
//  LMHGetWapShareURL.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-20.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHGetWapShareURL.h"

@implementation LMHGetWapShareURL
- (id)initWithUserID:(NSString *)userID
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (userID) {
            [subParams setObject:userID forKey:@"user_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
        
        
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_invitation_url";
}
@end
