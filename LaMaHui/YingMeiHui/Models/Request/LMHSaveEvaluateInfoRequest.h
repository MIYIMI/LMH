//
//  LMHSaveEvaluateInfoRequest.h
//  YingMeiHui
//
//  Created by 王凯 on 15-2-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHSaveEvaluateInfoRequest : KTBaseRequest
- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)token
    andEvaluationArr:(NSArray *)evaluationarr;
@end
