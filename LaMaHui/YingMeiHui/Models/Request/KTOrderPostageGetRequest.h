//
//  KTOrderPostageGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderPostageGetRequest : KTBaseRequest

- (id)initWithProductID:(long)productid
          andProductCnt:(NSInteger)productcnt
           andAddressID:(long)addressid;
@end
