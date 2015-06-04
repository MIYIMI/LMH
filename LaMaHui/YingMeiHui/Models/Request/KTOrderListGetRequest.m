//
//  KTOrderListGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderListGetRequest.h"

@implementation KTOrderListGetRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:5];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }

        if (pagesize != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pagesize] forKey:@"page_size"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:5] forKey:@"page_size"];
        }
        
        if (pageno != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pageno] forKey:@"page_no"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:1] forKey:@"page_no"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_user_orders";
}

@end
