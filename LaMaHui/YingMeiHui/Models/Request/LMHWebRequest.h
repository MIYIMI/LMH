//
//  LMHWebRequest.h
//  YingMeiHui
//
//  Created by 王凯 on 15-3-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHWebRequest : KTBaseRequest
- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
              andUrl:(NSString *)url
            andAname:(NSString *)aname;//页面追踪标示
@end
