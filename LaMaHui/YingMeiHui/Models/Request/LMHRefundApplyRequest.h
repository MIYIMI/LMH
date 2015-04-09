//
//  LMHRefundApplyRequest.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-31.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHRefundApplyRequest : KTBaseRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
    andorder_part_id:(NSString *)order_part_id
andrefund_express_status:(NSInteger)refund_express_status;
@end
