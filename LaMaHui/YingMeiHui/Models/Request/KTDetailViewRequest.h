//
//  KTDetailViewRequest.h
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTDetailViewRequest : KTBaseRequest

- (id)initWithProductID:(NSInteger)productid
              andUserID:(long)userid
           andUserToken:(NSString *)token
           andSeckillID:(NSInteger)seckillID;

@end
