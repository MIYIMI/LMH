//
//  KTAddressRegionInfoGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAddressRegionInfoGetRequest.h"

@implementation KTAddressRegionInfoGetRequest

- (id)initWithCode:(NSInteger)code
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (code != -1) {
            [subParams setObject:[NSNumber numberWithLong:code] forKey:@"parent_code"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"address_regioninfo_get";
}

@end
