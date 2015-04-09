//
//  KTOrderListGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderListGetRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;

@end
