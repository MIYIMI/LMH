//
//  LMHLimitedSeckillRequest.m
//  YingMeiHui
//
//  Created by 辣妈汇 on 14-10-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "LMHLimitedSeckillRequest.h"

@implementation LMHLimitedSeckillRequest

- (id)initWithPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        
        if (pagesize != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pagesize] forKey:@"page_size"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:20] forKey:@"page_size"];
        }
        
        if (pageno != -1) {
            [subParams setObject:[NSNumber numberWithInteger:pageno] forKey:@"page_no"];
        } else {
            [subParams setObject:[NSNumber numberWithInteger:1] forKey:@"page_no"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"get_limit_seckill";
}

@end
