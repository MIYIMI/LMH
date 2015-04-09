//
//  LMHTrackInfoRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-17.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHTrackInfoRequest.h"

@implementation LMHTrackInfoRequest

- (id)initWithOrderID:(NSString *)orderid
         andProductID:(NSString *)productid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        
        if (orderid) {
            [subParams setObject:orderid forKey:@"order_id"];
        }
        
        if (productid) {
            [subParams setObject:productid forKey:@"product_id"];
        }
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    return @"get_express_info";
}
@end
