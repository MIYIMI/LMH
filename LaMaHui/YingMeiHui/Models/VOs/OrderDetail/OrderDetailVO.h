//
//  OrderDetailVO.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoVO.h"

@interface detailAddressVO : NSObject
{
}

+ (detailAddressVO *)detailAddressVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *mobile;

@end

@interface TranckVO : NSObject
{
}

+ (NSArray *)TranckVOListWithArray:(NSArray *)array;
+ (TranckVO *)TranckVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *express_name;
@property(nonatomic, retain) NSString *express_num;
@property(nonatomic, retain) NSArray *express_detail;
@property(nonatomic, retain) NSString *context;
@property(nonatomic, retain) NSString *time;
@property(nonatomic, retain) NSString *ftime;

@end

@interface OrderDetailVO : NSObject
{
}

+ (OrderDetailVO *)OrderDetailVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSNumber *Code;
@property(nonatomic, retain) NSString *Msg;
@property(nonatomic, retain) detailAddressVO *user_info;
@property(nonatomic, retain) OrderInfoVO *order_info;
@property(nonatomic, retain) TranckVO *express_info;

@end


