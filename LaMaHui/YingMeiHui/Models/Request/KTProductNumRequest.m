//
//  KTProductNumRequest.m
//  YingMeiHui
//
//  Created by work on 14-11-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductNumRequest.h"

@implementation KTProductNumRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
        andProductID:(NSInteger)productid
           andCartID:(NSString *)cartid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithLong:productid] forKey:@"product_id"];
        }
        
        if (cartid) {
            [subParams setObject:cartid forKey:@"cart_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    return @"get_cart_goods_num";
}
@end
