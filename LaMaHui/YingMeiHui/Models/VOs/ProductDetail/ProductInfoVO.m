//
//  ProductInfoVO.m
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ProductInfoVO.h"
#import "ExtraInfoVO.h"
#import "ColorInfoVO.h"
#import "SizeInfoVO.h"
#import "SkuListVO.h"

@implementation ProductInfoVO

@synthesize Title;
@synthesize OurPrice;
@synthesize MarketPrice;
@synthesize SaleTip;
@synthesize soldoutDate;
@synthesize beginDate;
@synthesize diffTime;
@synthesize ExtraInfo;
@synthesize Pics;
@synthesize SoldOut;
@synthesize ColorPropName;
@synthesize ColorInfo;
@synthesize SizePropName;
@synthesize SizeInfo;
@synthesize IsFaved;
@synthesize PropTable;
@synthesize cartSku;
@synthesize Cartnum;
@synthesize productURL;
@synthesize detailArray;
@synthesize commentsNum;
@synthesize eventArray;
@synthesize buy_min;
@synthesize buy_max;
@synthesize is_exclusive;
@synthesize exclusive_price;
@synthesize share_content;
@synthesize share_title;
@synthesize type;
@synthesize seckill_id;
@synthesize is_start_buy;
@synthesize check_color_id;
@synthesize check_size_id;

+ (ProductInfoVO *)ProductInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ProductInfoVO ProductInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)ProductInfoVOWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ProductInfoVO ProductInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (ProductInfoVO *)ProductInfoVOWithDictionary:(NSDictionary *)dictionary
{
    ProductInfoVO *instance = [[ProductInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"pictures"] && ![[dictionary objectForKey:@"pictures"] isEqual:[NSNull null]]) {
            self.Pics = [dictionary objectForKey:@"pictures"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.Title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"our_price"] && ![[dictionary objectForKey:@"our_price"] isEqual:[NSNull null]]) {
            self.OurPrice = [dictionary objectForKey:@"our_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.MarketPrice = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"sale_tip"] && ![[dictionary objectForKey:@"sale_tip"] isEqual:[NSNull null]]) {
            self.SaleTip = [dictionary objectForKey:@"sale_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"end_at"] && ![[dictionary objectForKey:@"end_at"] isEqual:[NSNull null]]) {
            self.soldoutDate = [dictionary objectForKey:@"end_at"];
        }
        
        if (nil != [dictionary objectForKey:@"begin_at"] && ![[dictionary objectForKey:@"begin_at"] isEqual:[NSNull null]]) {
            self.beginDate = [dictionary objectForKey:@"begin_at"];
        }
        
        if (nil != [dictionary objectForKey:@"diff_time"] && ![[dictionary objectForKey:@"diff_time"] isEqual:[NSNull null]]) {
            self.diffTime = [dictionary objectForKey:@"diff_time"];
        }
        
        if (nil != [dictionary objectForKey:@"extra_info"] && ![[dictionary objectForKey:@"extra_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"extra_info"] isKindOfClass:[NSArray class]]) {
            self.ExtraInfo = [ExtraInfoVO ExtraInfoVOListWithArray:[dictionary objectForKey:@"extra_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"sold_out"] && ![[dictionary objectForKey:@"sold_out"] isEqual:[NSNull null]]) {
            self.SoldOut = [dictionary objectForKey:@"sold_out"];
        }
        
        if (nil != [dictionary objectForKey:@"color_prop_name"] && ![[dictionary objectForKey:@"color_prop_name"] isEqual:[NSNull null]]) {
            self.ColorPropName = [dictionary objectForKey:@"color_prop_name"];
        }
        
        if (nil != [dictionary objectForKey:@"color_info"] && ![[dictionary objectForKey:@"color_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"color_info"] isKindOfClass:[NSArray class]]) {
            self.ColorInfo = [ColorInfoVO ColorInfoVOListWithArray:[dictionary objectForKey:@"color_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"size_prop_name"] && ![[dictionary objectForKey:@"size_prop_name"] isEqual:[NSNull null]]) {
            self.SizePropName = [dictionary objectForKey:@"size_prop_name"];
        }
        
        if (nil != [dictionary objectForKey:@"size_info"] && ![[dictionary objectForKey:@"size_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"size_info"] isKindOfClass:[NSArray class]]) {
            self.SizeInfo = [SizeInfoVO SizeInfoVOListWithArray:[dictionary objectForKey:@"size_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"is_faved"] && ![[dictionary objectForKey:@"is_faved"] isEqual:[NSNull null]]) {
            self.IsFaved = [dictionary objectForKey:@"is_faved"];
        }
        
        if (nil != [dictionary objectForKey:@"prop_table"] && ![[dictionary objectForKey:@"prop_table"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"prop_table"] isKindOfClass:[NSArray class]]) {
            self.PropTable = [SkuListVO SkuListVOListWithArray:[dictionary objectForKey:@"prop_table"]];
        }
        
        if (nil != [dictionary objectForKey:@"cart_sku"] && ![[dictionary objectForKey:@"cart_sku"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"cart_sku"] isKindOfClass:[NSArray class]]) {
            self.cartSku = [dictionary objectForKey:@"cart_sku"];
        }
        
        if (nil != [dictionary objectForKey:@"cart_num"] && ![[dictionary objectForKey:@"cart_num"] isEqual:[NSNull null]]) {
            self.Cartnum = [dictionary objectForKey:@"cart_num"];
        }
        
        if (nil != [dictionary objectForKey:@"product_url"] && ![[dictionary objectForKey:@"product_url"] isEqual:[NSNull null]]) {
            self.productURL = [dictionary objectForKey:@"product_url"];
        }
        
        if (nil != [dictionary objectForKey:@"more_detail_img"] && ![[dictionary objectForKey:@"more_detail_img"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"more_detail_img"] isKindOfClass:[NSArray class]]) {
            self.detailArray = [dictionary objectForKey:@"more_detail_img"];
        }
        
        if (nil != [dictionary objectForKey:@"comments_count"] && ![[dictionary objectForKey:@"comments_count"] isEqual:[NSNull null]]) {
            self.commentsNum = [dictionary objectForKey:@"comments_count"];
        }
        
        if (nil != [dictionary objectForKey:@"event_arr"] && ![[dictionary objectForKey:@"event_arr"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"event_arr"] isKindOfClass:[NSArray class]]) {
            self.eventArray = [dictionary objectForKey:@"event_arr"];
        }
        
        if (nil != [dictionary objectForKey:@"user_buy_min"] && ![[dictionary objectForKey:@"user_buy_min"] isEqual:[NSNull null]]) {
            self.buy_min = [dictionary objectForKey:@"user_buy_min"];
        }
        
        if (nil != [dictionary objectForKey:@"user_buy_max"] && ![[dictionary objectForKey:@"user_buy_max"] isEqual:[NSNull null]]) {
            self.buy_max = [dictionary objectForKey:@"user_buy_max"];
        }
        
        if (nil != [dictionary objectForKey:@"is_exclusive"] && ![[dictionary objectForKey:@"is_exclusive"] isEqual:[NSNull null]]) {
            self.is_exclusive = [dictionary objectForKey:@"is_exclusive"];
        }
        
        if (nil != [dictionary objectForKey:@"exclusive_price"] && ![[dictionary objectForKey:@"exclusive_price"] isEqual:[NSNull null]]) {
            self.exclusive_price = [dictionary objectForKey:@"exclusive_price"];
        }
        
        if (nil != [dictionary objectForKey:@"share_content"] && ![[dictionary objectForKey:@"share_content"] isEqual:[NSNull null]]) {
            self.share_content = [dictionary objectForKey:@"share_content"];
        }
        
        if (nil != [dictionary objectForKey:@"share_title"] && ![[dictionary objectForKey:@"share_title"] isEqual:[NSNull null]]) {
            self.share_title = [dictionary objectForKey:@"share_title"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"seckill_id"] && ![[dictionary objectForKey:@"seckill_id"] isEqual:[NSNull null]]) {
            self.seckill_id = [dictionary objectForKey:@"seckill_id"];
        }
        
        if (nil != [dictionary objectForKey:@"is_start_buy"] && ![[dictionary objectForKey:@"is_start_buy"] isEqual:[NSNull null]]) {
            self.is_start_buy = [dictionary objectForKey:@"is_start_buy"];
        }
        
        if (nil != [dictionary objectForKey:@"check_color_id"] && ![[dictionary objectForKey:@"check_color_id"] isEqual:[NSNull null]]) {
            self.check_color_id = [dictionary objectForKey:@"check_color_id"];
        }
        
        if (nil != [dictionary objectForKey:@"check_size_id"] && ![[dictionary objectForKey:@"check_size_id"] isEqual:[NSNull null]]) {
            self.check_size_id = [dictionary objectForKey:@"check_size_id"];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", Pics];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"OurPrice = \"%@\"\r\n", OurPrice];
    [descriptionOutput appendFormat: @"MarketPrice = \"%@\"\r\n", MarketPrice];
    [descriptionOutput appendFormat: @"SaleTip = \"%@\"\r\n", SaleTip];
    [descriptionOutput appendFormat: @"SizeTablePic = \"%@\"\r\n", soldoutDate];
    [descriptionOutput appendFormat: @"ExtraInfo = \"%@\"\r\n", ExtraInfo];
    [descriptionOutput appendFormat: @"SoldOut = \"%@\"\r\n", SoldOut];
    [descriptionOutput appendFormat: @"ColorPropName = \"%@\"\r\n", ColorPropName];
    [descriptionOutput appendFormat: @"ColorInfo = \"%@\"\r\n", ColorInfo];
    [descriptionOutput appendFormat: @"SizePropName = \"%@\"\r\n", SizePropName];
    [descriptionOutput appendFormat: @"SizeInfo = \"%@\"\r\n", SizeInfo];
    [descriptionOutput appendFormat: @"IsFaved = \"%@\"\r\n", IsFaved];
    [descriptionOutput appendFormat: @"PropTable = \"%@\"\r\n", PropTable];
    [descriptionOutput appendFormat: @"commentsNum = \"%@\"\r\n", commentsNum];
    [descriptionOutput appendFormat: @"eventArray = \"%@\"\r\n", eventArray];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [Pics release];
    [Title release];
    [OurPrice release];
    [MarketPrice release];
    [SaleTip release];
    [soldoutDate release];
    [ExtraInfo release];
    [SoldOut release];
    [ColorPropName release];
    [ColorInfo release];
    [SizePropName release];
    [SizeInfo release];
    [IsFaved release];
    [PropTable release];
    [commentsNum release];
    [eventArray release];
    
    [super dealloc];
#endif
}

@end
