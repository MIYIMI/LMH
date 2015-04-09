//
//  KTRegisterRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTRegisterRequest : KTBaseRequest

- (id)initWithUserName:(NSString *)username
              password:(NSString *)password
             andCartID:(NSString *)cartid
          andSend_code:(NSString *)send_code
             andAlipay:(NSString *)alipayuser
         andGet_credit:(NSString *)get_credit
         andInvitation:(NSString *)invitation_code;

@end
