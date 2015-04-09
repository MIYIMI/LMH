//
//  KTThirdLoginRequest.m
//  YingMeiHui
//
//  Created by work on 14-9-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTThirdLoginRequest.h"

@implementation KTThirdLoginRequest

- (id)initWithOpenD:(NSString *)openid
         andUnionID:(NSString *)unionid
            andType:(NSString *)type
        andUsername:(NSString *)user
          andCartID:(NSString *)cartid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (openid) {
            [subParams setObject:openid forKey:@"openid"];
        }
        
        if (unionid) {
            [subParams setObject:unionid forKey:@"unionid"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        if (user) {
            [subParams setObject:user forKey:@"nickname"];
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
    return @"third_login";
}



@end
