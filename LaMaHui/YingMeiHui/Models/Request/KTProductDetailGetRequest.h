//
//  KTProductDetailGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTProductDetailGetRequest : KTBaseRequest

- (id)initWithProductID:(NSInteger)productid
              andUserID:(long)userid
           andUserToken:(NSString *)token;

@end
