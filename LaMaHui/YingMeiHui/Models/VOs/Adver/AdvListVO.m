//
//  AdvListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-14.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "AdvListVO.h"

@implementation AdvListVO

@synthesize Code;
@synthesize Msg;
@synthesize AdvList;

+ (AdvListVO *)AdvListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [AdvListVO AdvListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (AdvListVO *)AdvListVOWithDictionary:(NSDictionary *)dictionary
{
    AdvListVO *instance = [[AdvListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"advs"] && ![[dictionary objectForKey:@"advs"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"advs"] isKindOfClass:[NSArray class]]) {
            self.AdvList = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"advs"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"AdvList = \"%@\"\r\n", AdvList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[AdvList release];
    
    [super dealloc];
#endif
}

@end
