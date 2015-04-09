//
//  KTSubscribePostRequest.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTBaseRequest.h"

@interface KTSubscribePostRequest : KTBaseRequest

- (id)initWithBrandID:(NSInteger)brandid
              andType:(NSString *)type;

@end
