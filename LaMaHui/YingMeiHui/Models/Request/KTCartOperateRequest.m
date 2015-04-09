//
//  KTCartOperateRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCartOperateRequest.h"

static NSString *str = @"";

@implementation KTCartOperateRequest

- (id)initWithCartID:(NSString *)cartid
           andUserID:(NSString *)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
          andProduct:(NSArray *)product
           andGoodID:(NSNumber *)goodid
        andAddressID:(NSInteger)addressid
         andCouponNO:(NSString *)coponno
      andCoponUserID:(NSInteger)couponuserid
           andCredit:(CGFloat)credit
        andSeckillID:(NSInteger)skillid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:7];
        
        if (cartid) {
            [subParams setObject:cartid forKey:@"cart_id"];
        }
        
        if (userid) {
            [subParams setObject:userid forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        if (product) {
            [subParams setObject:product forKey:@"product"];
        }
        
        if (goodid) {
            [subParams setObject:goodid forKey:@"cart_goods_id"];
        }
        
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:addressid] forKey:@"address_id"];
        }
        
        if (coponno) {
            [subParams setObject:coponno forKey:@"coupon_sn"];
        }
        
        if (couponuserid >= 0) {
            [subParams setObject:[NSNumber numberWithInteger:couponuserid] forKey:@"coupon_record_id"];
        }
    
        if (credit >= 0) {
            [subParams setObject:[NSNumber numberWithFloat:credit] forKey:@"credit"];
        }
        
        if (skillid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:skillid] forKey:@"goods_seckill_id"];
        }
        
        str = type;
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    if ([str isEqualToString:@"list"]) {
        return @"getCartList";
    }
    if ([str isEqualToString:@"update"]) {
        return @"updateCartGoodsNum";
    }
    return @"cart_operate";
}

@end
