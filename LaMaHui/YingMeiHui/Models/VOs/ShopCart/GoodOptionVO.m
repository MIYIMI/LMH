//
//  GoodOptionVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-13.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "GoodOptionVO.h"

@implementation GoodOptionVO

@synthesize Value;
@synthesize Label;

+ (GoodOptionVO *)GoodOptionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [GoodOptionVO GoodOptionVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (GoodOptionVO *)GoodOptionVOWithDictionary:(NSDictionary *)dictionary
{
    GoodOptionVO *instance = [[GoodOptionVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)GoodOptionVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[GoodOptionVO GoodOptionVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"value"] && ![[dictionary objectForKey:@"value"] isEqual:[NSNull null]]) {
            self.Value = [dictionary objectForKey:@"value"];
        }
        
        if (nil != [dictionary objectForKey:@"label"] && ![[dictionary objectForKey:@"label"] isEqual:[NSNull null]]) {
            self.Label = [dictionary objectForKey:@"label"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Value = \"%@\"\r\n", Value];
    [descriptionOutput appendFormat: @"Label = \"%@\"\r\n", Label];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Value release];
	[Label release];
    
    [super dealloc];
#endif
}

@end
