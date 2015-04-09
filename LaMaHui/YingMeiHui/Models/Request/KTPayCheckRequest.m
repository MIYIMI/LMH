//
//  KTPayCheck.m
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTPayCheckRequest.h"

@implementation KTPayCheckRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
        andPayamount:(CGFloat)payamount
          andIDArray:(NSArray *)idarray
        andAddressID:(NSInteger)addressid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (payamount != -1) {
            [subParams setObject:[NSNumber numberWithFloat:payamount] forKey:@"pay_amount"];
        }
        
        if (idarray) {
            [subParams setObject:idarray forKey:@"productIdList"];
        }
        
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:addressid] forKey:@"address_id"];
        }
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    return @"order_sure";
}

@end
