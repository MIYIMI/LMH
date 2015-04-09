//
//  KTCommentsRequest.h
//  YingMeiHui
//
//  Created by work on 14-10-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTCommentsRequest : KTBaseRequest

- (id)initWithProductID:(NSInteger)productid
              andPageNO:(NSInteger)pageno
           andPageSize:(NSInteger)pagesize;

@end
