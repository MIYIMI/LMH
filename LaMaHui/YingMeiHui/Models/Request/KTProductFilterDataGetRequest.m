//
//  KTProductFilterDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductFilterDataGetRequest.h"

@implementation KTProductFilterDataGetRequest

- (id)initWithBrandID:(NSInteger)brandid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (brandid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:brandid] forKey:@"brand_id"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"productfilter_data_get";
}

@end
