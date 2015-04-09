//
//  KTModifyPasswordRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTModifyPasswordRequest : KTBaseRequest

- (id)initWithBindUsername:(NSString *)username
                 andUserID:(long)userid
              andUserToken:(NSString *)token
                   andCode:(NSString *)code
            andNewLoginPwd:(NSString *)newLoginPwd
            andOldLoginPwd:(NSString *)oldLoginPwd
              andNewPayPwd:(NSString *)newPayPwd
              andOldPayPwd:(NSString *)oldPayPwd;

@end
