//
//  LMHLimitedSeckillRequest.h
//  YingMeiHui
//
//  Created by 辣妈汇 on 14-10-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface LMHLimitedSeckillRequest : KTBaseRequest

- (id)initWithPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;
@end
