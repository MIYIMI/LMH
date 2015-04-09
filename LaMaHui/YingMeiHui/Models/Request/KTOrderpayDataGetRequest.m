//
//  KTOrderpayDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderpayDataGetRequest.h"

@implementation KTOrderpayDataGetRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
            andPayID:(long)payid
        andAddressID:(NSInteger)addressid
        andUserCopID:(NSString *)usercopid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:6];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (orderid) {
            [subParams setObject:orderid forKey:@"order_id"];
        }
        
        if (payid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:payid] forKey:@"pay_type"];
        }
        
        if (addressid!=-1) {
            [subParams setObject:[NSNumber numberWithInteger:addressid] forKey:@"address_id"];
        }
        
        if (usercopid) {
            [subParams setObject:usercopid forKey:@"user_coupon_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"orderpay_data_get";
}

@end
