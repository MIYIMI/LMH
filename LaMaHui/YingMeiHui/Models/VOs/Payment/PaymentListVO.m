//
//  PaymentListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "PaymentListVO.h"

@implementation PaymentListVO

@synthesize Code;
@synthesize Msg;
@synthesize PaymentList;

+ (PaymentListVO *)PaymentListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [PaymentListVO PaymentListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (PaymentListVO *)PaymentListVOWithDictionary:(NSDictionary *)dictionary
{
    PaymentListVO *instance = [[PaymentListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"paymentlist"] && ![[dictionary objectForKey:@"paymentlist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"paymentlist"] isKindOfClass:[NSArray class]]) {
            self.PaymentList = [PaymentVO PaymentVOListWithArray:[dictionary objectForKey:@"paymentlist"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"PaymentList = \"%@\"\r\n", PaymentList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[PaymentList release];
    
    [super dealloc];
#endif
}

@end
