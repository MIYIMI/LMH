//
//  CouponVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-16.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CouponVO.h"

@implementation CouponVO

@synthesize is_valid;
@synthesize title;
@synthesize begin_time;
@synthesize end_time;
@synthesize coupon_amount;
@synthesize coupon_rule;
@synthesize coupon_id;
@synthesize user_coupon_id;
@synthesize condition_money;
@synthesize special_condition;

+ (CouponVO *)CouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CouponVO CouponVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CouponVO *)CouponVOWithDictionary:(NSDictionary *)dictionary
{
    CouponVO *instance = [[CouponVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CouponVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CouponVO CouponVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"is_valid"] && ![[dictionary objectForKey:@"is_valid"] isEqual:[NSNull null]]) {
            self.is_valid = [dictionary objectForKey:@"is_valid"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"begin_time"] && ![[dictionary objectForKey:@"begin_time"] isEqual:[NSNull null]]) {
            self.begin_time = [dictionary objectForKey:@"begin_time"];
        }
        
        if (nil != [dictionary objectForKey:@"end_time"] && ![[dictionary objectForKey:@"end_time"] isEqual:[NSNull null]]) {
            self.end_time = [dictionary objectForKey:@"end_time"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_amount"] && ![[dictionary objectForKey:@"coupon_amount"] isEqual:[NSNull null]]) {
            self.coupon_amount = [dictionary objectForKey:@"coupon_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_rule"] && ![[dictionary objectForKey:@"coupon_rule"] isEqual:[NSNull null]]) {
            self.coupon_rule = [dictionary objectForKey:@"coupon_rule"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_sn"] && ![[dictionary objectForKey:@"coupon_sn"] isEqual:[NSNull null]]) {
            self.coupon_id = [dictionary objectForKey:@"coupon_sn"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_record_id"] && ![[dictionary objectForKey:@"coupon_record_id"] isEqual:[NSNull null]]) {
            self.user_coupon_id = [dictionary objectForKey:@"coupon_record_id"];
        }
        
        if (nil != [dictionary objectForKey:@"order_amount"] && ![[dictionary objectForKey:@"order_amount"] isEqual:[NSNull null]]) {
            self.order_amount = [dictionary objectForKey:@"order_amount"];
        }
        if (nil != [dictionary objectForKey:@"condition_money"] && ![[dictionary objectForKey:@"condition_money"] isEqual:[NSNull null]]) {
            self.condition_money = [dictionary objectForKey:@"condition_money"];
        }
        if (nil != [dictionary objectForKey:@"special_condition"] && ![[dictionary objectForKey:@"special_condition"] isEqual:[NSNull null]]) {
            self.special_condition = [dictionary objectForKey:@"special_condition"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"is_valid = \"%@\"\r\n", is_valid];
    [descriptionOutput appendFormat: @"title = \"%@\"\r\n", title];
    [descriptionOutput appendFormat: @"begin_time = \"%@\"\r\n", begin_time];
    [descriptionOutput appendFormat: @"expire_time = \"%@\"\r\n", end_time];
    [descriptionOutput appendFormat: @"coupon_amount = \"%@\"\r\n", coupon_amount];
    [descriptionOutput appendFormat: @"coupon_rule = \"%@\"\r\n", coupon_rule];
    [descriptionOutput appendFormat: @"coupon_rule = \"%@\"\r\n", condition_money];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[is_valid release];
	[title release];
	[expire_time release];
	[coupon_amount release];
	[coupon_rule release];
    [begin_time release];
    [coupon_id release];
    [user_coupon_id relase];
    [condition_money release];
    [coupon_sn release];
    [coupon_record_id relase];
    
    [super dealloc];
#endif
}

@end
