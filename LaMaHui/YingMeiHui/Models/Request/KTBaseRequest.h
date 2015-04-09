//
//  KTBaseRequest.h
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTInterfaceMethodConsts.h"

@interface KTBaseRequest : NSObject

@property (readonly, nonatomic) NSMutableDictionary * params;

//无输入参数初始化
- (id)initWithNone;

//操作接口号
- (NSString *)method;

//查询数据，这里会把公用的token之类的数据附加进去
- (NSDictionary *)query;

//该接口是否需要授权才能调用,默认为YES
- (BOOL)isPrivate;

@end
