//
//  ReturnOrderDetailVO.h
//  YingMeiHui
//
//  Created by work on 15-2-2.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailVO.h"

@interface ReturnOrderDetailVO : NSObject

+ (NSArray *)ReturnOrderDetailVOWithArray:(NSArray *)array;
+ (ReturnOrderDetailVO *)ReturnOrderDetailVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSNumber *refund_status;
@property(nonatomic, retain) NSString *fail_reason;
@property(nonatomic, retain) NSString *refuse_reason;
@property(nonatomic, retain) NSString *refund_reason2;
@property(nonatomic, retain) NSNumber *need_refund_goods;
@property(nonatomic, retain) NSString *refund_money_service;
@property(nonatomic, retain) NSString *refund_comment;
@property(nonatomic, retain) NSString *refund_partner_message;
@property(nonatomic, retain) NSNumber *order_time;
@property(nonatomic, retain) NSString *refund_note;
@property(nonatomic, retain) detailAddressVO *partner_info;
@property(nonatomic, retain) NSArray *refund_success_arr;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *refund_status_name;
@property(nonatomic, retain) NSString *refund_express_name;
@property(nonatomic, retain) NSString *refund_express_num;

@end

@interface ExpressVO : NSObject

+ (NSArray *)ExpressVOWithArray:(NSArray *)array;
+ (ExpressVO *)ExpressVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSNumber *express_id;
@property(nonatomic, retain) NSString *name;

@end

@interface WriteReasonVO : NSObject

+ (NSArray *)WriteReasonVOWithArray:(NSArray *)array;
+ (WriteReasonVO *)WriteReasonVOWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString *order_id;
@property(nonatomic, retain) NSNumber *order_part_id;
@property(nonatomic, retain) NSString *max_money;
@property(nonatomic, retain) NSNumber *quantity;
@property(nonatomic, retain) NSString *realname;
@property(nonatomic, retain) NSString *mobile;
@property(nonatomic, strong) NSArray *reason_type;
@property(nonatomic, strong) NSArray *reason_type2;

@end
