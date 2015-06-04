//
//  KTHomeListRequst.m
//  YingMeiHui
//
//  Created by work on 14-9-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTHomeListRequst.h"

@implementation KTHomeListRequst

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)usertoken
         andPageSize:(NSInteger)pagesize
            andPageNum:(NSInteger)pageno
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        
        if (userid > 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (usertoken) {
            [subParams setObject:usertoken forKey:@"user_token"];
        }
        
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
        
        NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_secret"];
        [subParams setObject:secret?secret:@"1234567890" forKey:@"app_cache_secret"];
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"homelist_data_get";
}


@end
