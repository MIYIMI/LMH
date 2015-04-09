//
//  KTRegisterRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTRegisterRequest.h"

@implementation KTRegisterRequest

- (id)initWithUserName:(NSString *)username
              password:(NSString *)password
             andCartID:(NSString *)cartid
          andSend_code:(NSString *)send_code
             andAlipay:(NSString *)alipayuser
         andGet_credit:(NSString *)get_credit
         andInvitation:(NSString *)invitation_code
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:6];
        if (username) {
            [subParams setObject:username forKey:@"username"];
        }
        
        if (password) {
            [subParams setObject:password forKey:@"password"];
        }
        
        if (cartid) {
            [subParams setObject:cartid forKey:@"cookie_cart_id"];
        }
        if (send_code) {
            [subParams setObject:send_code forKey:@"send_code"];
        }
        if (alipayuser) {
            [subParams setObject:alipayuser forKey:@"alipay_user"];
        }
        if (get_credit) {
            [subParams setObject:get_credit forKey:@"get_credit"];
        }
        if (invitation_code) {
            [subParams setObject:invitation_code forKey:@"invitation_code"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"regist_request";
}

@end
