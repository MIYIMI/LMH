//
//  KTFavOperateRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTFavOperateRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andProductID:(NSInteger)productid
             andType:(NSString *)type;

@end
