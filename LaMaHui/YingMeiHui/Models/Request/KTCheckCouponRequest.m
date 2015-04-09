//
//  KTCheckCouponRequest.m
//  YingMeiHui
//
//  Created by work on 14-9-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCheckCouponRequest.h"

@implementation KTCheckCouponRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
        andPayAmount:(CGFloat)payamount
         andCouponID:(NSString *)couponid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid > 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (payamount >= 0) {
            [subParams setObject:[NSNumber numberWithFloat:payamount] forKey:@"pay_amount"];
        }
        
        if (couponid) {
            [subParams setObject:couponid forKey:@"coupon_sn"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_user_coupon";
}

@end
