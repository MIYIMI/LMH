//
//  CheckCheckCouponVO.m
//  YingMeiHui
//
//  Created by work on 14-9-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CheckCouponVO.h"

@implementation CheckCouponVO
@synthesize code;
@synthesize msg;
@synthesize coupon_type;
@synthesize coupon_amount;
@synthesize order_amount;
@synthesize coupon_rule;
@synthesize user_coupon_id;
@synthesize couponid;

+ (CheckCouponVO *)CheckCouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CheckCouponVO CheckCouponVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CheckCouponVO *)CheckCouponVOWithDictionary:(NSDictionary *)dictionary
{
    CheckCouponVO *instance = [[CheckCouponVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CheckCouponVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CheckCouponVO CheckCouponVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"code"] && ![[dictionary objectForKey:@"code"] isEqual:[NSNull null]]) {
            self.code = [dictionary objectForKey:@"code"];
        }
        
        if (nil != [dictionary objectForKey:@"msg"] && ![[dictionary objectForKey:@"msg"] isEqual:[NSNull null]]) {
            self.msg = [dictionary objectForKey:@"msg"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_sn_info"] && ![[dictionary objectForKey:@"coupon_sn_info"] isEqual:[NSNull null]]) {
            self.coupon_type = [dictionary objectForKey:@"coupon_sn_info"];
        }
        
        if (nil != [dictionary objectForKey:@"order_amount"] && ![[dictionary objectForKey:@"order_amount"] isEqual:[NSNull null]]) {
            self.order_amount = [dictionary objectForKey:@"order_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_amount"] && ![[dictionary objectForKey:@"coupon_amount"] isEqual:[NSNull null]]) {
            self.coupon_amount = [dictionary objectForKey:@"coupon_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_rule"] && ![[dictionary objectForKey:@"coupon_rule"] isEqual:[NSNull null]]) {
            self.coupon_rule = [dictionary objectForKey:@"coupon_rule"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_record_id"] && ![[dictionary objectForKey:@"coupon_record_id"] isEqual:[NSNull null]]) {
            self.user_coupon_id = [dictionary objectForKey:@"coupon_record_id"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_sn"] && ![[dictionary objectForKey:@"coupon_sn"] isEqual:[NSNull null]]) {
            self.couponid = [dictionary objectForKey:@"coupon_sn"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"coupon_type = \"%@\"\r\n", coupon_type];
    [descriptionOutput appendFormat: @"user_coupon_id = \"%@\"\r\n", user_coupon_id];
    [descriptionOutput appendFormat: @"order_amount = \"%@\"\r\n", order_amount];
    [descriptionOutput appendFormat: @"coupon_rule = \"%@\"\r\n", coupon_rule];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [coupon_type release];
    [user_coupon_id release];
    [order_amount release];
    [coupon_rule release];;
    
    [super dealloc];
#endif
}

@end
