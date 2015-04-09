//
//  KTWalletPayRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-26.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTWalletPayRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andOrderID:(NSString *)orderid
           andPayPwd:(NSString *)paypwd;

@end
