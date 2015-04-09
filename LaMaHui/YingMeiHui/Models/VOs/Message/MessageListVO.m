//
//  MessageListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "MessageListVO.h"

@implementation MessageListVO

@synthesize Code;
@synthesize Msg;
@synthesize Total;
@synthesize MsgBeanList;

+ (MessageListVO *)MessageListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [MessageListVO MessageListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (MessageListVO *)MessageListVOWithDictionary:(NSDictionary *)dictionary
{
    MessageListVO *instance = [[MessageListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"total_count"] && ![[dictionary objectForKey:@"total_count"] isEqual:[NSNull null]]) {
            self.Total = [dictionary objectForKey:@"total_count"];
        }
        
        if (nil != [dictionary objectForKey:@"msg_list"] && ![[dictionary objectForKey:@"msg_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"msg_list"] isKindOfClass:[NSArray class]]) {
            self.MsgBeanList = [MessageBeanVO MessageBeanVOListWithArray:[dictionary objectForKey:@"msg_list"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"Total = \"%@\"\r\n", Total];
    [descriptionOutput appendFormat: @"OrderBeanList = \"%@\"\r\n", MsgBeanList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[Total release];
	[MsgBeanList release];
    
    [super dealloc];
#endif
}

@end
