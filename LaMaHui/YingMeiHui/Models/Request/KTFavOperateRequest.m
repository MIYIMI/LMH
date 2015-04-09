//
//  KTFavOperateRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTFavOperateRequest.h"

@implementation KTFavOperateRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andProductID:(NSInteger)productid
             andType:(NSString *)type
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithLong:productid] forKey:@"product_id"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"fav_operate";
}

@end
