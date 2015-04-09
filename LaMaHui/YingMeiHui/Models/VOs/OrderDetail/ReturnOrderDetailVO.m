//
//  ReturnOrderDetailVO.m
//  YingMeiHui
//
//  Created by work on 15-2-2.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "ReturnOrderDetailVO.h"

@implementation ReturnOrderDetailVO
@synthesize refund_status;
@synthesize refund_money_service;
@synthesize refuse_reason;
@synthesize fail_reason;
@synthesize need_refund_goods;
@synthesize refund_comment;
@synthesize refund_partner_message;
@synthesize order_time;
@synthesize partner_info;
@synthesize refund_success_arr;
@synthesize refund_note;
@synthesize refund_status_name;
@synthesize refund_express_name;
@synthesize refund_express_num;

+ (NSArray *)ReturnOrderDetailVOWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ReturnOrderDetailVO ReturnOrderDetailVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (ReturnOrderDetailVO *)ReturnOrderDetailVOWithDictionary:(NSDictionary *)dictionary{
    ReturnOrderDetailVO *instance = [[ReturnOrderDetailVO alloc] initWithDictionary:dictionary];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"refund_status"] && ![[dictionary objectForKey:@"refund_status"] isEqual:[NSNull null]]) {
            self.refund_status = [dictionary objectForKey:@"refund_status"];
        }
        
        if (nil != [dictionary objectForKey:@"fail_reason"] && ![[dictionary objectForKey:@"fail_reason"] isEqual:[NSNull null]]) {
            self.fail_reason = [dictionary objectForKey:@"fail_reason"];
        }
        
        if (nil != [dictionary objectForKey:@"refuse_reason"] && ![[dictionary objectForKey:@"refuse_reason"] isEqual:[NSNull null]]) {
            self.refuse_reason = [dictionary objectForKey:@"refuse_reason"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_reason2"] && ![[dictionary objectForKey:@"refund_reason2"] isEqual:[NSNull null]]) {
            self.refund_reason2 = [dictionary objectForKey:@"refund_reason2"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_money_service"] && ![[dictionary objectForKey:@"refund_money_service"] isEqual:[NSNull null]]) {
            self.refund_money_service = [dictionary objectForKey:@"refund_money_service"];
        }
        
        if (nil != [dictionary objectForKey:@"need_refund_goods"] && ![[dictionary objectForKey:@"need_refund_goods"] isEqual:[NSNull null]]) {
            self.need_refund_goods = [dictionary objectForKey:@"need_refund_goods"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_partner_message"] && ![[dictionary objectForKey:@"refund_partner_message"] isEqual:[NSNull null]]) {
            self.refund_partner_message = [dictionary objectForKey:@"refund_partner_message"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_comment"] && ![[dictionary objectForKey:@"refund_comment"] isEqual:[NSNull null]]) {
            self.refund_comment = [dictionary objectForKey:@"refund_comment"];
        }
        
        if (nil != [dictionary objectForKey:@"order_time"] && ![[dictionary objectForKey:@"order_time"] isEqual:[NSNull null]]) {
            self.order_time = [dictionary objectForKey:@"order_time"];
        }

        if (nil != dictionary[@"partner_info"] && ![dictionary[@"partner_info"] isEqual:[NSNull null]] && [dictionary[@"partner_info"] isKindOfClass:[NSDictionary class]]) {
            self.partner_info = [detailAddressVO detailAddressVOWithDictionary:dictionary[@"partner_info"]];
        }
        
        if (nil != dictionary[@"refund_success_arr"] && ![dictionary[@"refund_success_arr"] isEqual:[NSNull null]] && [dictionary[@"refund_success_arr"] isKindOfClass:[NSArray class]]) {
            self.refund_success_arr = dictionary[@"refund_success_arr"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_note"] && ![[dictionary objectForKey:@"refund_note"] isEqual:[NSNull null]]) {
            self.refund_note = [dictionary objectForKey:@"refund_note"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"refund_status_name"] && ![[dictionary objectForKey:@"refund_status_name"] isEqual:[NSNull null]]) {
            self.refund_status_name = [dictionary objectForKey:@"refund_status_name"];
        }
        if (nil != [dictionary objectForKey:@"refund_express_name"] && ![[dictionary objectForKey:@"refund_express_name"] isEqual:[NSNull null]]) {
            self.refund_express_name = [dictionary objectForKey:@"refund_express_name"];
        }
        if (nil != [dictionary objectForKey:@"refund_express_num"] && ![[dictionary objectForKey:@"refund_express_num"] isEqual:[NSNull null]]) {
            self.refund_express_num = [dictionary objectForKey:@"refund_express_num"];
        }
    }
    
    return self;
}

@end



@implementation ExpressVO
@synthesize express_id;
@synthesize name;

+ (NSArray *)ExpressVOWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ExpressVO ExpressVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (ExpressVO *)ExpressVOWithDictionary:(NSDictionary *)dictionary{
    ExpressVO *instance = [[ExpressVO alloc] initWithDictionary:dictionary];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"express_id"] && ![[dictionary objectForKey:@"express_id"] isEqual:[NSNull null]]) {
            self.express_id = [dictionary objectForKey:@"express_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
    }
    
    return self;
}

@end

@implementation WriteReasonVO
@synthesize order_id;
@synthesize order_part_id;
@synthesize max_money;
@synthesize quantity;
@synthesize realname;
@synthesize mobile;
@synthesize reason_type;
@synthesize reason_type2;

+ (NSArray *)WriteReasonVOWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[WriteReasonVO WriteReasonVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (WriteReasonVO *)WriteReasonVOWithDictionary:(NSDictionary *)dictionary{
    WriteReasonVO *instance = [[WriteReasonVO alloc] initWithDictionary:dictionary];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"order_id"] && ![[dictionary objectForKey:@"order_id"] isEqual:[NSNull null]]) {
            self.order_id = [dictionary objectForKey:@"order_id"];
        }
        
        if (nil != [dictionary objectForKey:@"order_part_id"] && ![[dictionary objectForKey:@"order_part_id"] isEqual:[NSNull null]]) {
            self.order_part_id = [dictionary objectForKey:@"order_part_id"];
        }
        
        if (nil != [dictionary objectForKey:@"max_money"] && ![[dictionary objectForKey:@"max_money"] isEqual:[NSNull null]]) {
            self.max_money = [dictionary objectForKey:@"max_money"];
        }
        
        if (nil != [dictionary objectForKey:@"quantity"] && ![[dictionary objectForKey:@"quantity"] isEqual:[NSNull null]]) {
            self.quantity = [dictionary objectForKey:@"quantity"];
        }
        
        if (nil != [dictionary objectForKey:@"realname"] && ![[dictionary objectForKey:@"realname"] isEqual:[NSNull null]]) {
            self.realname = [dictionary objectForKey:@"realname"];
        }
        
        if (nil != [dictionary objectForKey:@"mobile"] && ![[dictionary objectForKey:@"mobile"] isEqual:[NSNull null]]) {
            self.mobile = [dictionary objectForKey:@"mobile"];
        }
        
        if (nil != [dictionary objectForKey:@"reason_type"] && ![[dictionary objectForKey:@"reason_type"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"reason_type"] isKindOfClass:[NSArray class]]) {
            self.reason_type = [dictionary objectForKey:@"reason_type"];
        }
        
        if (nil != [dictionary objectForKey:@"reason_type2"] && ![[dictionary objectForKey:@"reason_type2"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"reason_type2"] isKindOfClass:[NSArray class]]) {
            self.reason_type2 = [dictionary objectForKey:@"reason_type2"];
        }
    }
    
    return self;
}

@end
