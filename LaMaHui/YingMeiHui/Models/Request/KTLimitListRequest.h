//
//  KTLimitListRequest.h
//  YingMeiHui
//
//  Created by work on 14-9-26.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTLimitListRequest : KTBaseRequest

- (id)initWithPageSize:(NSInteger)pagesize
        andPageNum:(NSInteger)pageno;

@end
