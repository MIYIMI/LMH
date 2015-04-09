//
//  KTOrderpayDataGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderpayDataGetRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
            andPayID:(long)payid
        andAddressID:(NSInteger)addressid
        andUserCopID:(NSString*)usercopid;

@end
