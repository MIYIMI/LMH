//
//  KTHomeListRequst.h
//  YingMeiHui
//
//  Created by work on 14-9-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTHomeListRequst : KTBaseRequest

- (id)initWithUserID:(NSInteger)userid
        andUserToken:(NSString *)usertoken
         andPageSize:(NSInteger)pagesize
           andPageNum:(NSInteger)pageno;

@end
