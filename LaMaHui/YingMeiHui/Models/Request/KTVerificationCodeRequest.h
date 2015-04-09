//
//  KTVerificationCodeRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTVerificationCodeRequest : KTBaseRequest

- (id)initWithBindUserID:(long)userid
            andUserToken:(NSString *)token
               andMobile:(NSString *)mobile
                 andType:(NSInteger)type;

- (id)initWithFindUsername:(NSString *)username
                 andMobile:(NSString *)mobile
                   andType:(NSInteger)type;

@end
