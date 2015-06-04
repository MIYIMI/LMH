//
//  LMHCartOperationsRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-12.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHCartOperationsRequest : KTBaseRequest
- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
    andGoods_id:(NSNumber *)goods_id
           andSku_id:(NSString *)sku_id;
@end
