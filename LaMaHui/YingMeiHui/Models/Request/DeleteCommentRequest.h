//
//  DeleteCommentRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-29.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface DeleteCommentRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
      andEvaluate_id:(NSNumber *)evaluate_id;

@end
