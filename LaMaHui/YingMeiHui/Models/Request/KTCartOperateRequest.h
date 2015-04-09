//
//  KTCartOperateRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTCartOperateRequest : KTBaseRequest

- (id)initWithCartID:(NSString *)cartid
           andUserID:(NSString *)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
          andProduct:(NSArray *)product
           andGoodID:(NSNumber *)goodid
        andAddressID:(NSInteger)addressid
         andCouponNO:(NSString *)coponno
      andCoponUserID:(NSInteger)couponuserid
           andCredit:(CGFloat)credit
        andSeckillID:(NSInteger)skillid;

@end
