//
//  LMHTrackInfoRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-17.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHTrackInfoRequest : KTBaseRequest

- (id)initWithOrderID:(NSString *)orderid
         andProductID:(NSString *)productid;

@end
