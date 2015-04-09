//
//  QAListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "QAListVO.h"

@implementation QAListVO

@synthesize Code;
@synthesize Msg;
@synthesize QAList;

+ (QAListVO *)QAListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [QAListVO QAListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (QAListVO *)QAListVOWithDictionary:(NSDictionary *)dictionary
{
    QAListVO *instance = [[QAListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"qa_list"] && ![[dictionary objectForKey:@"qa_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"qa_list"] isKindOfClass:[NSArray class]]) {
            self.QAList = [QAInfoVO QAInfoVOListWithArray:[dictionary objectForKey:@"qa_list"]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"QAList = \"%@\"\r\n", QAList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[QAList release];
    
    [super dealloc];
#endif
}

@end
