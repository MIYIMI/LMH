//
//  KTUserInfoGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTUserInfoGetRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token;

@end