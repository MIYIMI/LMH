//
//  LMHChangePasswordRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-2.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHChangePasswordRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          andold_pwd:(NSString *)old_pwd
          andnew_pwd:(NSString *)new_pwd;

@end
