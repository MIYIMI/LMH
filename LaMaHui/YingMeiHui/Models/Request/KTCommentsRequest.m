//
//  KTCommentsRequest.m
//  YingMeiHui
//
//  Created by work on 14-10-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTCommentsRequest.h"

@implementation KTCommentsRequest

- (id)initWithProductID:(NSInteger)productid
              andPageNO:(NSInteger)pageno
            andPageSize:(NSInteger)pagesize
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (productid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:productid] forKey:@"product_id"];
        }
        
        if (pageno != -1) {
            [subParams setObject:[NSNumber numberWithLong:pageno] forKey:@"page_no"];
        }
        
        if (pagesize != -1) {
            [subParams setObject:[NSNumber numberWithLong:pagesize] forKey:@"page_size"];
        }
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    return @"getComments";
}
@end
