//
//  KTVerificationCodeCheckRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTVerificationCodeCheckRequest : KTBaseRequest

- (id)initWithBindUserID:(long)userid
            andUserToken:(NSString *)token
                 andCode:(NSString *)code
                 andType:(NSInteger)type;

- (id)initWithFindUsername:(NSString *)username
                   andCode:(NSString *)code
                   andType:(NSInteger)type;

@end
