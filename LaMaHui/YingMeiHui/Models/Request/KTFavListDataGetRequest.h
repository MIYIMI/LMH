//
//  KTFavListDataGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTFavListDataGetRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;

@end
