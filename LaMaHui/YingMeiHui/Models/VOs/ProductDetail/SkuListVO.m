//
//  SkuListVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SkuListVO.h"

@implementation SkuListVO

@synthesize ColorID;
@synthesize SizeID;
@synthesize SkuNum;
@synthesize SkuID;
@synthesize ColorName;
@synthesize SizeName;
@synthesize imageUrl;

+ (SkuListVO *)SkuListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [SkuListVO SkuListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (SkuListVO *)SkuListVOWithDictionary:(NSDictionary *)dictionary
{
    SkuListVO *instance = [[SkuListVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)SkuListVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[SkuListVO SkuListVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"color_id"] && ![[dictionary objectForKey:@"color_id"] isEqual:[NSNull null]]) {
            self.ColorID = [dictionary objectForKey:@"color_id"];
        }
        
        if (nil != [dictionary objectForKey:@"size_id"] && ![[dictionary objectForKey:@"size_id"] isEqual:[NSNull null]]) {
            self.SizeID = [dictionary objectForKey:@"size_id"];
        }
        
        if (nil != [dictionary objectForKey:@"sku_num"] && ![[dictionary objectForKey:@"sku_num"] isEqual:[NSNull null]]) {
            self.SkuNum = [dictionary objectForKey:@"sku_num"];
        }
        
        if (nil != [dictionary objectForKey:@"sku_id"] && ![[dictionary objectForKey:@"sku_id"] isEqual:[NSNull null]]) {
            self.SkuID = [dictionary objectForKey:@"sku_id"];
        }
        
        if (nil != [dictionary objectForKey:@"color_name"] && ![[dictionary objectForKey:@"color_name"] isEqual:[NSNull null]]) {
            self.ColorName = [dictionary objectForKey:@"color_name"];
        }
        
        if (nil != [dictionary objectForKey:@"size_name"] && ![[dictionary objectForKey:@"size_name"] isEqual:[NSNull null]]) {
            self.SizeName = [dictionary objectForKey:@"size_name"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.imageUrl = [dictionary objectForKey:@"image"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"ColorID = \"%@\"\r\n", ColorID];
    [descriptionOutput appendFormat: @"SizeID = \"%@\"\r\n", SizeID];
    [descriptionOutput appendFormat: @"SkuNum = \"%@\"\r\n", SkuNum];
    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", SkuID];
    [descriptionOutput appendFormat: @"ColorID = \"%@\"\r\n", ColorName];
    [descriptionOutput appendFormat: @"SizeID = \"%@\"\r\n", SizeName];
    [descriptionOutput appendFormat: @"ColorID = \"%@\"\r\n", imageUrl];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[ColorID release];
	[SizeID release];
	[SkuNum release];
	[SkuID release];
    [ColorName release];
    [SizeName release];
    [imageUrl release];
    
    [super dealloc];
#endif
}

@end
