//
//  LMHCartOperationsRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-12.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHCartOperationsRequest.h"

@implementation LMHCartOperationsRequest

/**
 *  购物车 编辑状态下 点击options（尺码规格） 请求
 
 */
- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
    andGoods_id:(NSNumber *)goods_id
           andSku_id:(NSString *)sku_id
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:5];
        
        if (userid >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        if (goods_id) {
            [subParams setObject:goods_id forKey:@"goods_id"];
        }
        
        if (sku_id) {
            [subParams setObject:sku_id forKey:@"sku_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"cart_operate";
}
@end
