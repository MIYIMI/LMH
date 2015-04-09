//
//  KTOrderReturnRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderReturnRequest.h"

@implementation KTOrderReturnRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
          andOrderID:(NSInteger)orderid
          andContack:(NSString *)contact
        andLogistics:(NSString *)logistics
           andReason:(NSString *)reason
          andCompany:(NSString *)company
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:7];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (orderid != -1) {
            [subParams setObject:[NSNumber numberWithLong:orderid] forKey:@"order_id"];
        }
        
        if (contact) {
            [subParams setObject:contact forKey:@"contact"];
        }
        
        if (logistics) {
            [subParams setObject:logistics forKey:@"logistics"];
        }
        
        if (reason) {
            [subParams setObject:reason forKey:@"reason"];
        }
        
        if (company) {
            [subParams setObject:company forKey:@"out_express_name"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"order_return_request";
}

@end
