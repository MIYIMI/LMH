//
//  KTWXpayRequest.m
//  YingMeiHui
//
//  Created by work on 14-9-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTWXpayRequest.h"

@implementation KTWXpayRequest
- (id)initWithOrderID:(NSString *)order_no
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (order_no) {
            [subParams setObject:order_no forKey:@"order_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"weixinpay_prepay";
}


@end
