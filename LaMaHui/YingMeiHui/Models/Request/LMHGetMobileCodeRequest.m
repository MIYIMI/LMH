//
//  LMHGetMobileCodeRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-23.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHGetMobileCodeRequest.h"

@implementation LMHGetMobileCodeRequest

- (id)initWithMobile:(NSString *)mobile
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
//        if (userid != -1) {
//            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
//        }
//        
//        if (token) {
//            [subParams setObject:token forKey:@"user_token"];
//        }
        
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
        
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_mobile_code";
}

@end
