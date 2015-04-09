//
//  UserInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "UserInfoVO.h"

@implementation UserInfoVO

@synthesize Code;
@synthesize Msg;
@synthesize UserName;
@synthesize Money;
@synthesize PayedNum;
@synthesize WaitPayNum;
@synthesize AfterSaleNum;

+ (UserInfoVO *)UserInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [UserInfoVO UserInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (UserInfoVO *)UserInfoVOWithDictionary:(NSDictionary *)dictionary
{
    UserInfoVO *instance = [[UserInfoVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"username"] && ![[dictionary objectForKey:@"username"] isEqual:[NSNull null]]) {
            self.UserName = [dictionary objectForKey:@"username"];
        };
        
        if (nil != [dictionary objectForKey:@"money"] && ![[dictionary objectForKey:@"money"] isEqual:[NSNull null]]) {
            self.Money = [dictionary objectForKey:@"money"];
        };
        
        if (nil != [dictionary objectForKey:@"order_already_pay"] && ![[dictionary objectForKey:@"order_already_pay"] isEqual:[NSNull null]]) {
            self.PayedNum = [dictionary objectForKey:@"order_already_pay"];
        };
        
        if (nil != [dictionary objectForKey:@"order_wait_pay"] && ![[dictionary objectForKey:@"order_wait_pay"] isEqual:[NSNull null]]) {
            self.WaitPayNum = [dictionary objectForKey:@"order_wait_pay"];
        };
        
        if (nil != [dictionary objectForKey:@"order_aftersales"] && ![[dictionary objectForKey:@"order_aftersales"] isEqual:[NSNull null]]) {
            self.AfterSaleNum = [dictionary objectForKey:@"order_aftersales"];
        };
        
        if (nil != [dictionary objectForKey:@"cart_sku"] && ![[dictionary objectForKey:@"cart_sku"] isEqual:[NSNull null]]) {
            self.cartSkuArr = [dictionary objectForKey:@"cart_sku"];
        };
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"UserName = \"%@\"\r\n", UserName];
    [descriptionOutput appendFormat: @"Money = \"%@\"\r\n", Money];
    [descriptionOutput appendFormat: @"PayedNum = \"%@\"\r\n", PayedNum];
    [descriptionOutput appendFormat: @"WaitPayNum = \"%@\"\r\n", WaitPayNum];
    [descriptionOutput appendFormat: @"AfterSaleNum = \"%@\"\r\n", AfterSaleNum];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
    [UserName release];
    [Money release];
    [PayedNum release];
    [WaitPayNum release];
    [AfterSaleNum release];
    
    [super dealloc];
#endif
}

@end
