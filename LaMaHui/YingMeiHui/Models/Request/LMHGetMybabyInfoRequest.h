//
//  LMHGetMybabyInfoRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-1.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHGetMybabyInfoRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token;

@end
