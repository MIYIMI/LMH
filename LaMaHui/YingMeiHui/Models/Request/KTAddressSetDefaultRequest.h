//
//  KTAddressSetDefaultRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTAddressSetDefaultRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andAddressID:(long)addressid;

@end
