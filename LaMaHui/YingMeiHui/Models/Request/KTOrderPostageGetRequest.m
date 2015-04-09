//
//  KTOrderPostageGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTOrderPostageGetRequest.h"

@implementation KTOrderPostageGetRequest

- (id)initWithProductID:(long)productid
          andProductCnt:(NSInteger)productcnt
           andAddressID:(long)addressid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithLong:productid] forKey:@"product_id"];
        }
        
        [subParams setObject:[NSNumber numberWithInteger:productcnt] forKey:@"product_count"];
        
        if (addressid != -1) {
            [subParams setObject:[NSNumber numberWithLong:addressid] forKey:@"address_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"order_postage_get";
}

@end
