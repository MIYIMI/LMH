//
//  LMHMyCommentRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHMyCommentRequest : KTBaseRequest
- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
         andIs_reply:(NSString *)is_reply
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;
@end
