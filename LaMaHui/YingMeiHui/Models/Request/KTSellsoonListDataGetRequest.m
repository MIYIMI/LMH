//
//  KTSellsoonListDataGetRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTSellsoonListDataGetRequest.h"

@implementation KTSellsoonListDataGetRequest

- (id)initWithMenuID:(NSInteger)MID
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (MID != -1) {
            [subParams setObject:[NSNumber numberWithInteger:MID] forKey:@"menu_id"];
        }
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
            [subParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"device_token"];
        } else {
            [subParams setObject:@"" forKey:@"device_token"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"sellsoonlist_data_get";
}

@end
