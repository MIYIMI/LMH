//
//  PaymentVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "PaymentVO.h"

@implementation PaymentVO

@synthesize PayType;
@synthesize PayName;
@synthesize Bind;
@synthesize Money;

+ (PaymentVO *)PaymentVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [PaymentVO PaymentVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (PaymentVO *)PaymentVOWithDictionary:(NSDictionary *)dictionary
{
    PaymentVO *instance = [[PaymentVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)PaymentVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[PaymentVO PaymentVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"pay_type"] && ![[dictionary objectForKey:@"pay_type"] isEqual:[NSNull null]]) {
            self.PayType = [dictionary objectForKey:@"pay_type"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_name"] && ![[dictionary objectForKey:@"pay_name"] isEqual:[NSNull null]]) {
            self.PayName = [dictionary objectForKey:@"pay_name"];
        }
        
        if (nil != [dictionary objectForKey:@"bind"] && ![[dictionary objectForKey:@"bind"] isEqual:[NSNull null]]) {
            self.Bind = [dictionary objectForKey:@"bind"];
        }
        
        if (nil != [dictionary objectForKey:@"money"] && ![[dictionary objectForKey:@"money"] isEqual:[NSNull null]]) {
            self.Money = [dictionary objectForKey:@"money"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"PayType = \"%@\"\r\n", PayType];
    [descriptionOutput appendFormat: @"PayName = \"%@\"\r\n", PayName];
    [descriptionOutput appendFormat: @"Bind = \"%@\"\r\n", Bind];
    [descriptionOutput appendFormat: @"Money = \"%@\"\r\n", Money];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[PayType release];
	[PayName release];
	[Bind release];
	[Money release];
    
    [super dealloc];
#endif
}

@end
