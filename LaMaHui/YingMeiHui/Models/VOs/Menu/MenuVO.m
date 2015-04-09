//
//  MenuVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "MenuVO.h"

@implementation MenuVO

@synthesize MID;
@synthesize ParentID;
@synthesize TypeID;
@synthesize Icon;
@synthesize Name;
@synthesize ChildrenMenu;
@synthesize uuid;
@synthesize sortNum;

+ (MenuVO *)MenuVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [MenuVO MenuVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (MenuVO *)MenuVOWithDictionary:(NSDictionary *)dictionary
{
    MenuVO *instance = [[MenuVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)MenuVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        [resultsArray addObject:@"empty"];
    }
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        MenuVO *vo = [MenuVO MenuVOWithDictionary:entry];
        [resultsArray replaceObjectAtIndex:[vo.sortNum integerValue] withObject:vo];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"id"] && ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]]) {
            self.MID = [dictionary objectForKey:@"id"];
        }
        
        if (nil != [dictionary objectForKey:@"parentid"] && ![[dictionary objectForKey:@"parentid"] isEqual:[NSNull null]]) {
            self.ParentID = [dictionary objectForKey:@"parentid"];
        }
        
        if (nil != [dictionary objectForKey:@"typeid"] && ![[dictionary objectForKey:@"typeid"] isEqual:[NSNull null]]) {
            self.TypeID = [dictionary objectForKey:@"typeid"];
        }
        
        if (nil != [dictionary objectForKey:@"icon"] && ![[dictionary objectForKey:@"icon"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"icon"] isKindOfClass:[NSArray class]]) {
            self.Icon = [MenuVO MenuVOListWithArray:[dictionary objectForKey:@"icon"]];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.Name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"children_menu"] && ![[dictionary objectForKey:@"children_menu"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"children_menu"] isKindOfClass:[NSArray class]]) {
            self.ChildrenMenu = [MenuVO MenuVOListWithArray:[dictionary objectForKey:@"children_menu"]];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]) {
            self.uuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"sort_num"] && ![[dictionary objectForKey:@"sort_num"] isEqual:[NSNull null]]) {
            self.sortNum = [dictionary objectForKey:@"sort_num"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"MID = \"%@\"\r\n", MID];
    [descriptionOutput appendFormat: @"ParentID = \"%@\"\r\n", ParentID];
    [descriptionOutput appendFormat: @"TypeID = \"%@\"\r\n", TypeID];
    [descriptionOutput appendFormat: @"Icon = \"%@\"\r\n", Icon];
    [descriptionOutput appendFormat: @"Name = \"%@\"\r\n", Name];
    [descriptionOutput appendFormat: @"ChildrenMenu = \"%@\"\r\n", ChildrenMenu];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[MID release];
	[ParentID release];
	[TypeID release];
	[Icon release];
	[Name release];
	[ChildrenMenu release];
    
    [super dealloc];
#endif
}

@end
