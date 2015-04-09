//
//  KTOrderRequest.h
//  YingMeiHui
//
//  Created by work on 14-10-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
         andOrderID:(NSString *)orderid;

@end
