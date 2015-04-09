//
//  KTDetailViewRequest.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTDetailViewRequest.h"

@implementation KTDetailViewRequest

- (id)initWithProductID:(NSInteger)productid andUserID:(long)userid andUserToken:(NSString *)token andSeckillID:(NSInteger)seckillID
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (productid > 0) {
            [subParams setObject:[NSNumber numberWithInteger:productid] forKey:@"product_id"];
        }
        
        if (userid > 0 ) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        if (seckillID > 0 ) {
            [subParams setObject:[NSNumber numberWithLong:seckillID] forKey:@"goods_seckill_id"];
        }
        
         NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    return @"get_goods_detail";
}

@end
