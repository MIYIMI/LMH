//
//  LMHChangeSKUOperations.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-13.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHChangeSKUOperations.h"

@implementation LMHChangeSKUOperations

/**
 *  购物车修改options属性后 “确定”按钮  请求
 
 */
- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
           andItemID:(NSNumber *)itemid
         andOldSkuID:(NSString *)oldskuid
          andProduct:(NSArray  *)product;
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:6];
        
        if (userid >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        if (itemid) {
            [subParams setObject:itemid forKey:@"cart_goods_id"];
        }
        
        if (oldskuid) {
            [subParams setObject:oldskuid forKey:@"old_sku_id"];
        }
        
        if (product) {
            [subParams setObject:product forKey:@"product"];
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
