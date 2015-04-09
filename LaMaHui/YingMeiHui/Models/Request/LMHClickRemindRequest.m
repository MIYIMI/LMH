//
//  LMHClickRemindRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-2-4.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHClickRemindRequest.h"

@implementation LMHClickRemindRequest

- (id)initWithGoods_id:(NSNumber *)goods_id
         andbegin_at:(NSNumber *)begin_at
          andis_flag:(NSNumber *)is_flag
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        
        if (goods_id) {
            [subParams setObject:goods_id forKey:@"goods_id"];
        }
        if (begin_at) {
            [subParams setObject:begin_at forKey:@"begin_at"];
        }
        if (is_flag) {
            [subParams setObject:is_flag forKey:@"is_flag"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"save_seckill_remind";
}

@end
