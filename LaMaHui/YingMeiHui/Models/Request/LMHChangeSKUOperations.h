//
//  LMHChangeSKUOperations.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-13.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHChangeSKUOperations : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
             andType:(NSString *)type
           andItemID:(NSNumber *)itemid
         andOldSkuID:(NSString *)oldskuid
          andProduct:(NSArray  *)product;
@end
