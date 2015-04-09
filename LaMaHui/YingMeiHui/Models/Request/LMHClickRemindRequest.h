//
//  LMHClickRemindRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-2-4.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHClickRemindRequest : KTBaseRequest

- (id)initWithGoods_id:(NSNumber *)goods_id
         andbegin_at:(NSNumber *)begin_at
          andis_flag:(NSNumber *)is_flag;

@end
