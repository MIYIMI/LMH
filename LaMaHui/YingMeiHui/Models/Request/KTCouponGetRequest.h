//
//  KTCouponGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-16.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTCouponGetRequest : KTBaseRequest
{
    NSString *orderID;
}

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid;

@end
