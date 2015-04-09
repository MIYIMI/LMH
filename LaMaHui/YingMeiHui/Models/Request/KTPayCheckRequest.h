//
//  KTPayCheck.h
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTPayCheckRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
        andPayamount:(CGFloat)payamount
          andIDArray:(NSArray *)idarray
         andAddressID:(NSInteger)addressid;

@end
