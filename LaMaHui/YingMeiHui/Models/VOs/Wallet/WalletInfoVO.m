//
//  WalletInfoVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "WalletInfoVO.h"

@implementation WalletInfoVO

@synthesize Code;
@synthesize Msg;
@synthesize Total;
@synthesize Usable;
@synthesize Dealing;
@synthesize Bind;

+ (WalletInfoVO *)WalletInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [WalletInfoVO WalletInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (WalletInfoVO *)WalletInfoVOWithDictionary:(NSDictionary *)dictionary
{
    WalletInfoVO *instance = [[WalletInfoVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"total"] && ![[dictionary objectForKey:@"total"] isEqual:[NSNull null]]) {
            self.Total = [dictionary objectForKey:@"total"];
        };
        
        if (nil != [dictionary objectForKey:@"usable"] && ![[dictionary objectForKey:@"usable"] isEqual:[NSNull null]]) {
            self.Usable = [dictionary objectForKey:@"usable"];
        };
        
        if (nil != [dictionary objectForKey:@"dealing"] && ![[dictionary objectForKey:@"dealing"] isEqual:[NSNull null]]) {
            self.Dealing = [dictionary objectForKey:@"dealing"];
        };
        
        if (nil != [dictionary objectForKey:@"bind"] && ![[dictionary objectForKey:@"bind"] isEqual:[NSNull null]]) {
            self.Bind = [dictionary objectForKey:@"bind"];
        };
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"Total = \"%@\"\r\n", Total];
    [descriptionOutput appendFormat: @"Usable = \"%@\"\r\n", Usable];
    [descriptionOutput appendFormat: @"Dealing = \"%@\"\r\n", Dealing];
    [descriptionOutput appendFormat: @"Bind = \"%@\"\r\n", Bind];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
    [Total release];
    [Usable release];
    [Dealing release];
    [Bind release];
    
    [super dealloc];
#endif
}

@end
