//
//  KTWalletPayRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-26.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTWalletPayRequest.h"

@implementation KTWalletPayRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
           andPayPwd:(NSString *)paypwd
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (orderid) {
            [subParams setObject:orderid forKey:@"order_id"];
        }
        
        if (paypwd) {
            [subParams setObject:paypwd forKey:@"pay_pwd"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"orderpay_data_sub";
}

@end
