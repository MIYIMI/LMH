//
//  LMHChangeUserIconRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-22.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHChangeUserIconRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
          user_image:(NSString *)user_image
           user_name:(NSString *)user_name;

@end
