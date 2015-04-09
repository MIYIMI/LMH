//
//  KTOrderItemGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderItemGetRequest.h"

@implementation KTOrderItemGetRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
           andPartID:(NSInteger)partner_id
      andOrderStates:(NSInteger)states
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
        
        if (partner_id) {
            [subParams setObject:[NSNumber numberWithInteger:partner_id] forKey:@"partner_id"];
        }
        
        if (states >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:states] forKey:@"pay_order_state"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_order_detail";
}

@end
