//
//  CouponListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CouponListVO.h"

@implementation CouponListVO

@synthesize Code;
@synthesize Msg;
@synthesize invalid;
@synthesize valid;
@synthesize coupon_list;
@synthesize has_order;
@synthesize will_invalid;

+ (CouponListVO *)CouponListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CouponListVO CouponListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CouponListVO *)CouponListVOWithDictionary:(NSDictionary *)dictionary
{
    CouponListVO *instance = [[CouponListVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"code"] && ![[dictionary objectForKey:@"code"] isEqual:[NSNull null]]) {
            self.Code = [dictionary objectForKey:@"code"];
        }
        
        if (nil != [dictionary objectForKey:@"msg"] && ![[dictionary objectForKey:@"msg"] isEqual:[NSNull null]]) {
            self.Msg = [dictionary objectForKey:@"msg"];
        }
        
        if (nil != [dictionary objectForKey:@"invalid"] && ![[dictionary objectForKey:@"invalid"] isEqual:[NSNull null]]) {
            self.invalid = [dictionary objectForKey:@"invalid"];
        }
        
        if (nil != [dictionary objectForKey:@"valid"] && ![[dictionary objectForKey:@"valid"] isEqual:[NSNull null]]) {
            self.valid = [dictionary objectForKey:@"valid"];
        }
        
        if (nil != [dictionary objectForKey:@"has_order"] && ![[dictionary objectForKey:@"has_order"] isEqual:[NSNull null]]) {
            self.has_order = [dictionary objectForKey:@"has_order"];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_list"] && ![[dictionary objectForKey:@"coupon_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"coupon_list"] isKindOfClass:[NSArray class]]) {
            self.coupon_list = [CouponVO CouponVOWithArray:[dictionary objectForKey:@"coupon_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"will_invalid"] && ![[dictionary objectForKey:@"will_invalid"] isEqual:[NSNull null]]) {
            self.will_invalid = [dictionary objectForKey:@"will_invalid"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"CouponList = \"%@\"\r\n", coupon_list];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[code release];
	[msg release];
	[couponList release];
    [has_order release];
    [will_invalid release];
    
    [super dealloc];
#endif
}

@end
