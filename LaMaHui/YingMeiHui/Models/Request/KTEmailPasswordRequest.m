//
//  KTEmailPasswordRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTEmailPasswordRequest.h"

@implementation KTEmailPasswordRequest

- (id)initWithEmail:(NSString *)email
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (email) {
            [subParams setObject:email forKey:@"email"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"email_password_request";
}

@end
