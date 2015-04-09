//
//  KTProductNumRequest.h
//  YingMeiHui
//
//  Created by work on 14-11-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTProductNumRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
        andProductID:(NSInteger)productid
           andCartID:(NSString *)cartid;

@end
