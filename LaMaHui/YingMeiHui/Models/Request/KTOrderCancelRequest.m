//
//  KTOrderCancelRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderCancelRequest.h"

@implementation KTOrderCancelRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (orderid) {
            [subParams setObject:orderid forKey:@"order_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"order_cancel_request";
}

@end