//
//  KTOrderSubmitPostRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderSubmitPostRequest.h"

@implementation KTOrderSubmitPostRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andAddressID:(long)addressid
        andProductID:(long)productid
       andProductCnt:(NSInteger)productcnt
          andColorID:(NSInteger)colorid
           andSizeID:(NSInteger)sizeid
         andCouponID:(long)couponid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithLong:addressid] forKey:@"address_id"];
        }
        
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithLong:productid] forKey:@"product_id"];
        }
        
        if (productcnt > 0) {
            [subParams setObject:[NSNumber numberWithInteger:productcnt] forKey:@"product_count"];
        }
        
        if (colorid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:colorid] forKey:@"color_id"];
        }
        
        if (sizeid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:sizeid] forKey:@"size_id"];
        }
        
        if (couponid != -1) {
            [subParams setObject:[NSNumber numberWithLong:couponid] forKey:@"coupon_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"order_submit_post";
}

@end
