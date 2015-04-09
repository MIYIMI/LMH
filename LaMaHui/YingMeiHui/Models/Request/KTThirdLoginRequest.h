//
//  KTThirdLoginRequest.h
//  YingMeiHui
//
//  Created by work on 14-9-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTThirdLoginRequest : KTBaseRequest
- (id)initWithOpenD:(NSString *)openid
         andUnionID:(NSString *)unionid
            andType:(NSString *)type
        andUsername:(NSString *)user
          andCartID:(NSString *)cartid;

@end
