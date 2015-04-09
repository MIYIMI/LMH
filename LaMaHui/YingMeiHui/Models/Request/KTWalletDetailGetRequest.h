//
//  KTWalletDetailGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTWalletDetailGetRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;

@end
