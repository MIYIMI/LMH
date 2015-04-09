//
//  ChanelRequest.m
//  YingMeiHui
//
//  Created by work on 14-11-13.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTChanelRequest.h"


static NSInteger _type = 0;
@implementation KTChanelRequest

- (id)initWithUserID:(NSInteger)userid
             andType:(NSInteger)type
        andUserToken:(NSString *)usertoken
            andPageSize:(NSInteger)pagesize
            andPageNum:(NSInteger)pageno
           andChanleID:(NSInteger)channelid
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
        if (userid > 0) {
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if (usertoken) {
            [subParams setObject:usertoken forKey:@"user_token"];
        }
        
        if (channelid != -1) {
            [subParams setObject:[NSNumber numberWithLong:channelid] forKey:@"channel_id"];
        }
        
        _type = type;
        
        if (pagesize != -1) {
            [subParams setObject:[NSNumber numberWithLong:pagesize] forKey:@"page_size"];
        }
        
        if (pageno != -1) {
            [subParams setObject:[NSNumber numberWithLong:pageno] forKey:@"page_no"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    return self;
}

- (NSString *)method
{
    if (_type == 7) {
        return @"get_goods_by_event";
    }
    return @"get_channel_by_id";
}
@end
