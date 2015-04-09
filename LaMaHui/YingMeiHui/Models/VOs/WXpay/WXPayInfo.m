//
//  WXPayInfo.m
//  YingMeiHui
//
//  Created by work on 14-9-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "WXPayInfo.h"

@implementation WXPayInfo

@synthesize AppId;
@synthesize NonceStr;
@synthesize Wxpackage;
@synthesize PartnerId;
@synthesize Prepayid;
@synthesize Timestamp;
@synthesize Sign;

+ (WXPayInfo *)WXPayInfoWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [WXPayInfo WXPayInfoWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (WXPayInfo *)WXPayInfoWithDictionary:(NSDictionary *)dictionary
{
    WXPayInfo *instance = [[WXPayInfo alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)WXPayInfoListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[WXPayInfo WXPayInfoWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"appid"] && ![[dictionary objectForKey:@"appid"] isEqual:[NSNull null]]) {
            self.AppId = [dictionary objectForKey:@"appid"];
        }
        
        if (nil != [dictionary objectForKey:@"noncestr"] && ![[dictionary objectForKey:@"noncestr"] isEqual:[NSNull null]]) {
            self.NonceStr = [dictionary objectForKey:@"noncestr"];
        }
        
        if (nil != [dictionary objectForKey:@"wxpackage"] && ![[dictionary objectForKey:@"wxpackage"] isEqual:[NSNull null]]) {
            self.Wxpackage = [dictionary objectForKey:@"wxpackage"];
        }
        
        if (nil != [dictionary objectForKey:@"partnerid"] && ![[dictionary objectForKey:@"partnerid"] isEqual:[NSNull null]]) {
            self.PartnerId = [dictionary objectForKey:@"partnerid"];
        }
        
        if (nil != [dictionary objectForKey:@"prepayid"] && ![[dictionary objectForKey:@"prepayid"] isEqual:[NSNull null]]) {
            self.Prepayid = [dictionary objectForKey:@"prepayid"];
        }
        
        if (nil != [dictionary objectForKey:@"timestamp"] && ![[dictionary objectForKey:@"timestamp"] isEqual:[NSNull null]]) {
            self.Timestamp = [dictionary objectForKey:@"timestamp"];
        }
        
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]) {
            self.Sign = [dictionary objectForKey:@"sign"];
        }
        
    }
    
    return self;
}

- (NSString *)description
{
//    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
//    [descriptionOutput appendFormat: @"ProductID = \"%@\"\r\n", ProductID];
//    [descriptionOutput appendFormat: @"ItemID = \"%@\"\r\n", ItemID];
//    [descriptionOutput appendFormat: @"SellPrice = \"%@\"\r\n", SellPrice];
//    [descriptionOutput appendFormat: @"OriginalPrice = \"%@\"\r\n", OriginalPrice];
//    [descriptionOutput appendFormat: @"Qty = \"%@\"\r\n", Qty];
//    [descriptionOutput appendFormat: @"ProductName = \"%@\"\r\n", ProductName];
//    [descriptionOutput appendFormat: @"ProductImage = \"%@\"\r\n", ProductImage];
//    [descriptionOutput appendFormat: @"SkuID = \"%@\"\r\n", SkuID];
//    [descriptionOutput appendFormat: @"BrandName = \"%@\"\r\n", BrandName];
//    [descriptionOutput appendFormat: @"Options = \"%@\"\r\n", Options];
//    
//    return JSONAutoRelease(descriptionOutput);
    return nil;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[AppId release];
	[NonceStr release];
	[Pachage release];
	[PartnerId release];
	[Prepayid release];
	[Timestamp release];
	[Sign release];
    
    [super dealloc];
#endif
}

@end
