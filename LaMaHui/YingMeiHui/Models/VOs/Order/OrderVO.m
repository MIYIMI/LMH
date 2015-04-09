//
//  OrderVO.m
//  YingMeiHui
//
//  Created by work on 14-10-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "OrderVO.h"

@implementation OrderVO

@synthesize address;
@synthesize order;
@synthesize paymentlist;

+ (OrderVO *)OrderVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [OrderVO OrderVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (OrderVO *)OrderVOWithDictionary:(NSDictionary *)dictionary
{
    OrderVO *instance = [[OrderVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)OrderVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[OrderVO OrderVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        
        if (nil != [dictionary objectForKey:@"order"] && ![[dictionary objectForKey:@"order"] isEqual:[NSNull null]]) {
            self.order = [dictionary objectForKey:@"order"];
        }
        
        if (nil != [dictionary objectForKey:@"paymentlist"] && ![[dictionary objectForKey:@"paymentlist"] isEqual:[NSNull null]]) {
            self.paymentlist = [dictionary objectForKey:@"paymentlist"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"OrderPrice = \"%@\"\r\n", address];
    [descriptionOutput appendFormat: @"CreateTime = \"%@\"\r\n", paymentlist];
    [descriptionOutput appendFormat: @"PayTime = \"%@\"\r\n", order];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [address release];
    [paymentlist release];
    [CreateTime release];
    [order release];
    
    [super dealloc];
#endif
}

@end
