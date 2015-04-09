//
//  KTAdverDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTAdverDataGetRequest.h"

@implementation KTAdverDataGetRequest

- (id)initWithType:(NSString *)adverType
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (adverType) {
            [subParams setObject:adverType forKey:@"type"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"adver_data_get";
}

@end
