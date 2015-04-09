//
//  KTLoginRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTLoginRequest.h"

@implementation KTLoginRequest

- (id)initWithUserName:(NSString *)username
              password:(NSString *)password
                cartID:(NSString *)cartid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (username) {
            [subParams setObject:username forKey:@"username"];
        }
        
        if (password) {
            [subParams setObject:password forKey:@"password"];
        }
        
        if (cartid) {
            [subParams setObject:cartid forKey:@"cookie_cart_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"login_request";
}

@end
