//
//  KTProductListDataGetRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTProductListDataGetRequest : KTBaseRequest

- (id)initWithBrandID:(NSInteger)brandid
       andFilterStock:(NSInteger)stock
            andCateID:(NSInteger)cateid
            andSizeID:(NSInteger)sizeid
         andProductID:(NSInteger)productid
              andSort:(NSInteger)sort
          andPageSize:(NSInteger)pagesize
           andPageNum:(NSInteger)pageno
          andPlatform:(NSString *)platform
            andUserID:(NSInteger)userid;

@end
