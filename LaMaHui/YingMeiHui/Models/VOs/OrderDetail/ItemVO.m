//
//  ItemVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ItemVO.h"

@implementation ItemVO

@synthesize ProductID;
@synthesize ProductTitle;
@synthesize PicUrl;
@synthesize ProductPrice;
@synthesize ColorName;
@synthesize SizeName;
@synthesize ColorPropName;
@synthesize SizePropName;
@synthesize ItemNum;
@synthesize Status;

+ (ItemVO *)ItemVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ItemVO ItemVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ItemVO *)ItemVOWithDictionary:(NSDictionary *)dictionary
{
    ItemVO *instance = [[ItemVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ItemVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ItemVO ItemVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.ProductID = [dictionary objectForKey:@"product_id"];
        };
        
        if (nil != [dictionary objectForKey:@"product_title"] && ![[dictionary objectForKey:@"product_title"] isEqual:[NSNull null]]) {
            self.ProductTitle = [dictionary objectForKey:@"product_title"];
        };
        
        if (nil != [dictionary objectForKey:@"pic_url"] && ![[dictionary objectForKey:@"pic_url"] isEqual:[NSNull null]]) {
            self.PicUrl = [dictionary objectForKey:@"pic_url"];
        };
        
        if (nil != [dictionary objectForKey:@"item_price"] && ![[dictionary objectForKey:@"item_price"] isEqual:[NSNull null]]) {
            self.ProductPrice = [dictionary objectForKey:@"item_price"];
        };
        
        if (nil != [dictionary objectForKey:@"color_value"] && ![[dictionary objectForKey:@"color_value"] isEqual:[NSNull null]]) {
            self.ColorName = [dictionary objectForKey:@"color_value"];
        };
        
        if (nil != [dictionary objectForKey:@"size_value"] && ![[dictionary objectForKey:@"size_value"] isEqual:[NSNull null]]) {
            self.SizeName = [dictionary objectForKey:@"size_value"];
        };
        
        if (nil != [dictionary objectForKey:@"color_name"] && ![[dictionary objectForKey:@"color_name"] isEqual:[NSNull null]]) {
            self.ColorPropName = [dictionary objectForKey:@"color_name"];
        };
        
        if (nil != [dictionary objectForKey:@"size_name"] && ![[dictionary objectForKey:@"size_name"] isEqual:[NSNull null]]) {
            self.SizePropName = [dictionary objectForKey:@"size_name"];
        };
        
        if (nil != [dictionary objectForKey:@"item_num"] && ![[dictionary objectForKey:@"item_num"] isEqual:[NSNull null]]) {
            self.ItemNum = [dictionary objectForKey:@"item_num"];
        };
        
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]) {
            self.Status = [dictionary objectForKey:@"status"];
        };    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ProductID = \"%@\"\r\n", ProductID];
    [descriptionOutput appendFormat: @"ProductTitle = \"%@\"\r\n", ProductTitle];
    [descriptionOutput appendFormat: @"PicUrl = \"%@\"\r\n", PicUrl];
    [descriptionOutput appendFormat: @"ProductPrice = \"%@\"\r\n", ProductPrice];
    [descriptionOutput appendFormat: @"ColorName = \"%@\"\r\n", ColorName];
    [descriptionOutput appendFormat: @"SizeName = \"%@\"\r\n", SizeName];
    [descriptionOutput appendFormat: @"ColorPropName = \"%@\"\r\n", ColorPropName];
    [descriptionOutput appendFormat: @"SizePropName = \"%@\"\r\n", SizePropName];
    [descriptionOutput appendFormat: @"ItemNum = \"%@\"\r\n", ItemNum];
    [descriptionOutput appendFormat: @"Status = \"%@\"\r\n", Status];
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [ProductID release];
    [ProductTitle release];
    [PicUrl release];
    [ProductPrice release];
    [ColorName release];
    [SizeName release];
    [ColorPropName release];
    [SizePropName release];
    [ItemNum release];
    [Status release];
    [super dealloc];
#endif
}

@end
