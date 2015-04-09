//
//  KTBrandlistDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBrandlistDataGetRequest.h"

@implementation KTBrandlistDataGetRequest

- (id)initWithMenuID:(NSInteger)MID
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:3];
        if (MID != -1) {
            [subParams setObject:[NSNumber numberWithInteger:MID] forKey:@"menu_id"];
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
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"brandlist_data_get";
}

@end
