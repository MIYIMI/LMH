//
//  KTCheckCouponRequest.h
//  YingMeiHui
//
//  Created by work on 14-9-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTCheckCouponRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
          andPayAmount:(CGFloat)payamount
         andCouponID:(NSString *)couponid;
@end
