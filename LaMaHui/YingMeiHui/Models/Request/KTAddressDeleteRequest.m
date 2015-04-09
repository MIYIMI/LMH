//
//  KTAddressDeleteRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAddressDeleteRequest.h"

@implementation KTAddressDeleteRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andAddressID:(long)addressid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithLong:addressid] forKey:@"address_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"address_delete";
}

@end
