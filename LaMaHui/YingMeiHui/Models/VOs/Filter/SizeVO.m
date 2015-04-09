//
//  SizeVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SizeVO.h"

@implementation SizeVO

@synthesize SizeID;
@synthesize SizeName;

+ (SizeVO *)SizeVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SizeVO SizeVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SizeVO *)SizeVOWithDictionary:(NSDictionary *)dictionary
{
    SizeVO *instance = [[SizeVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SizeVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[SizeVO SizeVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"size_id"] && ![[dictionary objectForKey:@"size_id"] isEqual:[NSNull null]]) {
            self.SizeID = [dictionary objectForKey:@"size_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.SizeName = [dictionary objectForKey:@"name"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"SizeID = \"%@\"\r\n", SizeID];
    [descriptionOutput appendFormat: @"SizeName = \"%@\"\r\n", SizeName];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[SizeID release];
	[SizeName release];
    
    [super dealloc];
#endif
}

@end
