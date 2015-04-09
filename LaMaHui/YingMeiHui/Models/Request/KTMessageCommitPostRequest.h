//
//  KTMessageCommitPostRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTMessageCommitPostRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
             Content:(NSString *)content;

@end
