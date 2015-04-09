//
//  AddressListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "AddressListVO.h"

@implementation AddressListVO

@synthesize Code;
@synthesize Msg;
@synthesize AddressList;

+ (AddressListVO *)AddressListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [AddressListVO AddressListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (AddressListVO *)AddressListVOWithDictionary:(NSDictionary *)dictionary
{
    AddressListVO *instance = [[AddressListVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"address_list"] && ![[dictionary objectForKey:@"address_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"address_list"] isKindOfClass:[NSArray class]]) {
            //self.AddressList =
            NSArray *tempArray = [AddressVO AddressVOListWithArray:[dictionary objectForKey:@"address_list"]];
            NSMutableArray *sortArray = [NSMutableArray arrayWithArray:tempArray];
            [sortArray sortUsingComparator:^NSComparisonResult(AddressVO *obj1, AddressVO *obj2) {
                NSInteger value1 = obj1.IsDefault.boolValue ? 1 : 0;
                NSInteger value2 = obj2.IsDefault.boolValue ? 1 : 0;
                if (value1 > value2) {
                    return NSOrderedAscending;
                }
                if (value1 < value2) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];
            self.AddressList = [NSArray arrayWithArray:sortArray];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"AddressList = \"%@\"\r\n", AddressList];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[AddressList release];
    
    [super dealloc];
#endif
}

@end
