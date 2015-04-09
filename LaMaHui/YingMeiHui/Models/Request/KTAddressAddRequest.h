//
//  KTAddressAddRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTAddressAddRequest : KTBaseRequest

- (id)initWithAddressID:(NSInteger)addressid
              andUserID:(NSInteger)userid
           andUserToken:(NSString *)usertoken
                andName:(NSString *)name
              andMobile:(NSString *)mobile
              andDetail:(NSString *)detail
          andRegionCode:(NSInteger)regioncode
            andDeafault:(BOOL)is_default;

- (id)initWithAddressID:(NSInteger)addressid
              andUserID:(NSInteger)userid
           andUserToken:(NSString *)usertoken
                andName:(NSString *)name
              andMobile:(NSString *)mobile
              andDetail:(NSString *)detail
          andRegionCode:(NSInteger)regioncode
            andDeafault:(BOOL)is_default
             andOrderID:(NSString *)orderID;

@end
