//
//  KTBrandlistDataGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTBrandlistDataGetRequest : KTBaseRequest

- (id)initWithMenuID:(NSInteger)MID
         andPageSize:(NSInteger)pagesize
          andPageNum:(NSInteger)pageno;

@end
