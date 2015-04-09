//
//  SellsoonSectionListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-1.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SellsoonSectionListVO.h"

@implementation SellsoonSectionListVO

@synthesize Code;
@synthesize Msg;
@synthesize SellsoonSectionList;

+ (SellsoonSectionListVO *)SellsoonSectionListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SellsoonSectionListVO SellsoonSectionListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SellsoonSectionListVO *)SellsoonSectionListVOWithDictionary:(NSDictionary *)dictionary
{
    SellsoonSectionListVO *instance = [[SellsoonSectionListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"sellsoonsections"] && ![[dictionary objectForKey:@"sellsoonsections"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"sellsoonsections"] isKindOfClass:[NSArray class]]) {
            self.SellsoonSectionList = [SellsoonSectionVO SellsoonSectionVOListWithArray:[dictionary objectForKey:@"sellsoonsections"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"SellsoonSectionList = \"%@\"\r\n", SellsoonSectionList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[SellsoonSectionList release];
    
    [super dealloc];
#endif
}

@end
