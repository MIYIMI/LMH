//
//  KTAddressAddRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAddressAddRequest.h"

@implementation KTAddressAddRequest

- (id)initWithAddressID:(NSInteger)addressid
              andUserID:(NSInteger)userid
           andUserToken:(NSString *)usertoken
                andName:(NSString *)name
              andMobile:(NSString *)mobile
              andDetail:(NSString *)detail
          andRegionCode:(NSInteger)regioncode
            andDeafault:(BOOL)is_default
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:6];
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithLong:addressid] forKey:@"address_id"];
        }
        
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (usertoken) {
            [subParams setObject:usertoken forKey:@"user_token"];
        }
        
        if (name) {
            [subParams setObject:name forKey:@"name"];
        }
        
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
        }
        
        if (detail) {
            [subParams setObject:detail forKey:@"detail"];
        }
        
        if (regioncode != -1) {
            [subParams setObject:[NSNumber numberWithLong:regioncode] forKey:@"region_code"];
        }
        
        [subParams setObject:[NSNumber numberWithBool:is_default] forKey:@"is_default"];
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (id)initWithAddressID:(NSInteger)addressid
              andUserID:(NSInteger)userid
           andUserToken:(NSString *)usertoken
                andName:(NSString *)name
              andMobile:(NSString *)mobile
              andDetail:(NSString *)detail
          andRegionCode:(NSInteger)regioncode
            andDeafault:(BOOL)is_default
             andOrderID:(NSString *)orderID
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:6];
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithLong:addressid] forKey:@"address_id"];
        }
        
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (usertoken) {
            [subParams setObject:usertoken forKey:@"user_token"];
        }
        
        if (name) {
            [subParams setObject:name forKey:@"name"];
        }
        
        if (mobile) {
            [subParams setObject:mobile forKey:@"mobile"];
        }
        
        if (detail) {
            [subParams setObject:detail forKey:@"detail"];
        }
        
        if (regioncode != -1) {
            [subParams setObject:[NSNumber numberWithLong:regioncode] forKey:@"region_code"];
        }
        
        if (orderID) {
            [subParams setObject:orderID forKey:@"order_id"];
        }
        
        [subParams setObject:[NSNumber numberWithBool:is_default] forKey:@"is_default"];
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"address_add";
}

@end
