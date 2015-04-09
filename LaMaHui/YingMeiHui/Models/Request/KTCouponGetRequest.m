//
//  KTCouponGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-16.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCouponGetRequest.h"

@implementation KTCouponGetRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid > 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (orderid) {
            [subParams setObject:orderid forKey:@"order_id"];
            orderID = orderid;
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    if (!orderID) {
        return @"coupon_get";
    }
    return @"pay_coupon_get";
}

@end
