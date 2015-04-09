//
//  CateListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-4.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CateListVO.h"

@implementation CateListVO

@synthesize Code;
@synthesize Msg;
@synthesize CateList;

+ (CateListVO *)CateListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [CateListVO CateListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (CateListVO *)CateListVOWithDictionary:(NSDictionary *)dictionary
{
    CateListVO *instance = [[CateListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"catelist"] && ![[dictionary objectForKey:@"catelist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"catelist"] isKindOfClass:[NSArray class]]) {
            self.CateList = [CateVO CateVOListWithArray:[dictionary objectForKey:@"catelist"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"CateList = \"%@\"\r\n", CateList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[CateList release];
    
    [super dealloc];
#endif
}

@end
