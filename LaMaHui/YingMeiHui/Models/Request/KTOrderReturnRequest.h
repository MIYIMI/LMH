//
//  KTOrderReturnRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTOrderReturnRequest : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
          andOrderID:(NSInteger)orderid
          andContack:(NSString *)contact
        andLogistics:(NSString *)logistics
           andReason:(NSString *)reason
          andCompany:(NSString *)company;

@end
