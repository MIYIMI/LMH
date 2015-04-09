//
//  CateVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CateVO.h"

@implementation CateVO

@synthesize CateID;
@synthesize CateName;
@synthesize Cnt;
@synthesize SizeList;

+ (CateVO *)CateVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CateVO CateVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CateVO *)CateVOWithDictionary:(NSDictionary *)dictionary
{
    CateVO *instance = [[CateVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)CateVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CateVO CateVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"cate_id"] && ![[dictionary objectForKey:@"cate_id"] isEqual:[NSNull null]]) {
            self.CateID = [dictionary objectForKey:@"cate_id"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.CateName = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"cnt"] && ![[dictionary objectForKey:@"cnt"] isEqual:[NSNull null]]) {
            self.Cnt = [dictionary objectForKey:@"cnt"];
        }
        
        if (nil != [dictionary objectForKey:@"sizelist"] && ![[dictionary objectForKey:@"sizelist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"sizelist"] isKindOfClass:[NSArray class]]) {
            self.SizeList = [SizeVO SizeVOListWithArray:[dictionary objectForKey:@"sizelist"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"CateID = \"%@\"\r\n", CateID];
    [descriptionOutput appendFormat: @"CateName = \"%@\"\r\n", CateName];
    [descriptionOutput appendFormat: @"Cnt = \"%@\"\r\n", Cnt];
    [descriptionOutput appendFormat: @"SizeList = \"%@\"\r\n", SizeList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[CateID release];
	[CateName release];
	[Cnt release];
	[SizeList release];
    
    [super dealloc];
#endif
}

@end
