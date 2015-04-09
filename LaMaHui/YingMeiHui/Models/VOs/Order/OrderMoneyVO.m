//
//  OrderMoneyVO.m
//  YingMeiHui
//
//  Created by work on 14-10-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderMoneyVO.h"

@implementation OrderMoneyVO
@synthesize pay_amount;
@synthesize pay_coupon_money;
@synthesize pay_credit;
@synthesize pay_freight;
@synthesize pay_money;
@synthesize app_discount_money;


+ (OrderMoneyVO *)OrderMoneyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderMoneyVO OrderMoneyVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderMoneyVO *)OrderMoneyVOWithDictionary:(NSDictionary *)dictionary
{
    OrderMoneyVO *instance = [[OrderMoneyVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderMoneyVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderMoneyVO OrderMoneyVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"pay_amount"] && ![[dictionary objectForKey:@"pay_amount"] isEqual:[NSNull null]]) {
            self.pay_amount = [dictionary objectForKey:@"pay_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_coupon_money"] && ![[dictionary objectForKey:@"pay_coupon_money"] isEqual:[NSNull null]]) {
            self.pay_coupon_money = [dictionary objectForKey:@"pay_coupon_money"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_credit"] && ![[dictionary objectForKey:@"pay_credit"] isEqual:[NSNull null]]) {
            self.pay_credit = [dictionary objectForKey:@"pay_credit"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_money"] && ![[dictionary objectForKey:@"pay_money"] isEqual:[NSNull null]]) {
            self.pay_money = [dictionary objectForKey:@"pay_money"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_freight"] && ![[dictionary objectForKey:@"pay_freight"] isEqual:[NSNull null]]) {
            self.pay_freight = [dictionary objectForKey:@"pay_freight"];
        }
        
        if (nil != [dictionary objectForKey:@"app_discount_money"] && ![[dictionary objectForKey:@"app_discount_money"] isEqual:[NSNull null]]) {
            self.app_discount_money = [dictionary objectForKey:@"app_discount_money"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"OrderPrice = \"%@\"\r\n", pay_amount];
    [descriptionOutput appendFormat: @"CreateTime = \"%@\"\r\n", pay_coupon_money];
    [descriptionOutput appendFormat: @"PayTime = \"%@\"\r\n", pay_credit];
    [descriptionOutput appendFormat: @"OrderPrice = \"%@\"\r\n", pay_money];
    [descriptionOutput appendFormat: @"CreateTime = \"%@\"\r\n", pay_freight];
    [descriptionOutput appendFormat: @"PayTime = \"%@\"\r\n", app_discount_money];
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [pay_amount release];
    [pay_coupon_money release];
    [pay_credit release];
    [pay_money release];
    [pay_freight release];
    [app_discount_money release];
    
    [super dealloc];
#endif
}

@end
