//
//  KTOrderSubmitPostRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderSubmitPostRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andAddressID:(long)addressid
        andProductID:(long)productid
       andProductCnt:(NSInteger)productcnt
          andColorID:(NSInteger)colorid
           andSizeID:(NSInteger)sizeid
         andCouponID:(long)couponid;

@end
