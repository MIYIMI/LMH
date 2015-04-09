//
//  QAInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-7-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "QAInfoVO.h"

@implementation QAInfoVO

@synthesize QATitle;
@synthesize QAContent;

+ (QAInfoVO *)QAInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [QAInfoVO QAInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (QAInfoVO *)QAInfoVOWithDictionary:(NSDictionary *)dictionary
{
    QAInfoVO *instance = [[QAInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)QAInfoVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[QAInfoVO QAInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"qa_title"] && ![[dictionary objectForKey:@"qa_title"] isEqual:[NSNull null]]) {
            self.QATitle = [dictionary objectForKey:@"qa_title"];
        }
        
        if (nil != [dictionary objectForKey:@"qa_content"] && ![[dictionary objectForKey:@"qa_content"] isEqual:[NSNull null]]) {
            self.QAContent = [dictionary objectForKey:@"qa_content"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"QATitle = \"%@\"\r\n", QATitle];
    [descriptionOutput appendFormat: @"QAContent = \"%@\"\r\n", QAContent];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[QATitle release];
	[QAContent release];
    
    [super dealloc];
#endif
}

@end
