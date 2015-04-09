//
//  ChanelRequest.h
//  YingMeiHui
//
//  Created by work on 14-11-13.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTChanelRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
             andType:(NSInteger)type
        andUserToken:(NSString *)usertoken
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno
         andChanleID:(NSInteger)channelid;

@end
