//
//  KTProductSkunumGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProductSkunumGetRequest.h"

@implementation KTProductSkunumGetRequest

- (id)initWithProductID:(NSInteger)productid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:productid] forKey:@"product_id"];
        }

        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"product_skunum_get";
}

@end
