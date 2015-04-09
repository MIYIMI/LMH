//
//  LMHSecurityCodeRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-11.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHSecurityCodeRequest.h"

@implementation LMHSecurityCodeRequest

- (id)initWithMobile:(NSString *)mobile
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
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
    return @"send_identify";
}


@end
