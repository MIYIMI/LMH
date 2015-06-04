//
//  KTStartupInfoGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTStartupInfoGetRequest.h"

@implementation KTStartupInfoGetRequest

- (id)init
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"menu_secret"];
        [subParams setObject:secret?secret:@"1234567890" forKey:@"app_cache_secret"];
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"startup_info_get";
}

@end
