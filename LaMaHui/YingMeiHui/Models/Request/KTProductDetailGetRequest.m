//
//  KTProductDetailGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductDetailGetRequest.h"

@implementation KTProductDetailGetRequest

- (id)initWithProductID:(NSInteger)productid
              andUserID:(long)userid
           andUserToken:(NSString *)token
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:productid] forKey:@"product_id"];
        }
        
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"product_detail_get";
}

@end
