//
//  LMHRefundApplyRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-31.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHRefundApplyRequest.h"

@implementation LMHRefundApplyRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
    andorder_part_id:(NSString *)order_part_id
andrefund_express_status:(NSInteger)refund_express_status
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        if (order_part_id) {
            [subParams setObject:order_part_id forKey:@"order_part_id"];
        }
        if (refund_express_status) {
            [subParams setObject:[NSNumber numberWithInteger:refund_express_status] forKey:@"refund_express_status"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}
    
- (NSString *)method
{
    return @"get_refund_order_by_part_id";
}



@end
