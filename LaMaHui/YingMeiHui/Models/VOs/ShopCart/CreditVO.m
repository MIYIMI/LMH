//
//  CreditVO.m
//  YingMeiHui
//
//  Created by work on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CreditVO.h"

@implementation CreditVO

@synthesize user_credit;
@synthesize user_max_credit;
@synthesize credit_to_moeny;

+ (CreditVO *)CreditVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CreditVO CreditVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CreditVO *)CreditVOWithDictionary:(NSDictionary *)dictionary
{
    CreditVO *instance = [[CreditVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CreditVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CreditVO CreditVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"user_credit"] && ![[dictionary objectForKey:@"user_credit"] isEqual:[NSNull null]]) {
            self.user_credit = [dictionary objectForKey:@"user_credit"];
        }
        
        if (nil != [dictionary objectForKey:@"user_max_credit"] && ![[dictionary objectForKey:@"user_max_credit"] isEqual:[NSNull null]]) {
            self.user_max_credit = [dictionary objectForKey:@"user_max_credit"];
        }
        
        if (nil != [dictionary objectForKey:@"credit_to_moeny"] && ![[dictionary objectForKey:@"credit_to_moeny"] isEqual:[NSNull null]]) {
            self.credit_to_moeny = [dictionary objectForKey:@"credit_to_moeny"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", user_max_credit];
    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", user_credit];
    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", credit_to_moeny];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [user_credit release];
    [user_max_credit release];
    [credit_to_moeny release];
    
    [super dealloc];
#endif
}

@end
