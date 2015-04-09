//
//  OrderCheckVO.m
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderCheckVO.h"
#import "AddressVO.h"
#import "CouponVO.h"
#import "CreditVO.h"

@implementation OrderCheckVO

@synthesize address_list;
@synthesize coupon_list;
@synthesize credit_list;
@synthesize code;
@synthesize msg;

+ (OrderCheckVO *)OrderCheckVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderCheckVO OrderCheckVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderCheckVO *)OrderCheckVOWithDictionary:(NSDictionary *)dictionary
{
    OrderCheckVO *instance = [[OrderCheckVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderCheckVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderCheckVO OrderCheckVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"address_list"] && ![[dictionary objectForKey:@"address_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"address_list"] isKindOfClass:[NSArray class]]) {
            self.address_list = [AddressVO AddressVOListWithArray:[dictionary objectForKey:@"address_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"coupon_list"] && ![[dictionary objectForKey:@"coupon_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"coupon_list"] isKindOfClass:[NSArray class]]) {
            self.coupon_list = [CouponVO CouponVOWithArray:[dictionary objectForKey:@"coupon_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"credit_list"] && ![[dictionary objectForKey:@"credit_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"credit_list"] isKindOfClass:[NSDictionary class]]) {
            self.credit_list = [CreditVO CreditVOWithDictionary:[dictionary objectForKey:@"credit_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"code"] && ![[dictionary objectForKey:@"code"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"code"] isKindOfClass:[NSArray class]]) {
            self.code = [dictionary objectForKey:@"code"];
        }
        
        if (nil != [dictionary objectForKey:@"msg"] && ![[dictionary objectForKey:@"msg"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"msg"] isKindOfClass:[NSArray class]]) {
            self.msg = [dictionary objectForKey:@"msg"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", address_list];
    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", coupon_list];
    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", credit_list];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [address_list release];
    [coupon_list release];
    [credit_list release];
    
    [super dealloc];
#endif
}

@end
