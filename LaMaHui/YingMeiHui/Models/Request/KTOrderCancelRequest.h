//
//  KTOrderCancelRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderCancelRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid;

@end
