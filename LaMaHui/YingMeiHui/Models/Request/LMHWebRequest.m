//
//  LMHWebRequest.m
//  YingMeiHui
//
//  Created by 王凯 on 15-3-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHWebRequest.h"

@implementation LMHWebRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
              andUrl:(NSString *)url
            andAname:(NSString *)aname
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (userid >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (url) {
            [subParams setObject:url forKey:@"url"];
        }
        
        if (aname) {
            [subParams setObject:aname forKey:@"aname"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"ins_url_log";
}
@end
