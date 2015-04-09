//
//  LMHResetPasswordRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-24.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHResetPasswordRequest : KTBaseRequest

- (id)initWithcode:(NSString *)code
           mobile:(NSString *)mobile
           new_pwd:(NSString *)new_pwd;

@end
