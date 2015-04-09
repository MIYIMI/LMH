//
//  ProductDetailVO.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-7.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "ProductDetailVO.h"

@implementation ProductDetailVO

@synthesize Code;
@synthesize Msg;
@synthesize BrandTitle;
@synthesize Pics;
@synthesize Title;
@synthesize OurPrice;
@synthesize MarketPrice;
@synthesize SaleTip;
@synthesize SizeTablePic;
@synthesize ExtraInfo;
@synthesize MoreDetail;
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

+ (ProductDetailVO *)ProductDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ProductDetailVO ProductDetailVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ProductDetailVO *)ProductDetailVOWithDictionary:(NSDictionary *)dictionary
{
    ProductDetailVO *instance = [[ProductDetailVO alloc] initWithDictionary:dictionary];
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
        
        if (nil != [dictionary objectForKey:@"brand_title"] && ![[dictionary objectForKey:@"brand_title"] isEqual:[NSNull null]]) {
            self.BrandTitle = [dictionary objectForKey:@"brand_title"];
        }
        
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
        
        if (nil != [dictionary objectForKey:@"size_table_pic"] && ![[dictionary objectForKey:@"size_table_pic"] isEqual:[NSNull null]]) {
            self.SizeTablePic = [dictionary objectForKey:@"size_table_pic"];
        }
        
        if (nil != [dictionary objectForKey:@"extra_info"] && ![[dictionary objectForKey:@"extra_info"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"extra_info"] isKindOfClass:[NSArray class]]) {
            self.ExtraInfo = [ExtraInfoVO ExtraInfoVOListWithArray:[dictionary objectForKey:@"extra_info"]];
        }
        
        if (nil != [dictionary objectForKey:@"more_detail"] && ![[dictionary objectForKey:@"more_detail"] isEqual:[NSNull null]]) {
            self.MoreDetail = [dictionary objectForKey:@"more_detail"];
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
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"Code = \"%@\"\r\n", Code];
    [descriptionOutput appendFormat: @"Msg = \"%@\"\r\n", Msg];
    [descriptionOutput appendFormat: @"BrandTitle = \"%@\"\r\n", BrandTitle];
    [descriptionOutput appendFormat: @"Pics = \"%@\"\r\n", Pics];
    [descriptionOutput appendFormat: @"Title = \"%@\"\r\n", Title];
    [descriptionOutput appendFormat: @"OurPrice = \"%@\"\r\n", OurPrice];
    [descriptionOutput appendFormat: @"MarketPrice = \"%@\"\r\n", MarketPrice];
    [descriptionOutput appendFormat: @"SaleTip = \"%@\"\r\n", SaleTip];
    [descriptionOutput appendFormat: @"SizeTablePic = \"%@\"\r\n", SizeTablePic];
    [descriptionOutput appendFormat: @"ExtraInfo = \"%@\"\r\n", ExtraInfo];
    [descriptionOutput appendFormat: @"MoreDetail = \"%@\"\r\n", MoreDetail];
    [descriptionOutput appendFormat: @"SoldOut = \"%@\"\r\n", SoldOut];
    [descriptionOutput appendFormat: @"ColorPropName = \"%@\"\r\n", ColorPropName];
    [descriptionOutput appendFormat: @"ColorInfo = \"%@\"\r\n", ColorInfo];
    [descriptionOutput appendFormat: @"SizePropName = \"%@\"\r\n", SizePropName];
    [descriptionOutput appendFormat: @"SizeInfo = \"%@\"\r\n", SizeInfo];
    [descriptionOutput appendFormat: @"IsFaved = \"%@\"\r\n", IsFaved];
    [descriptionOutput appendFormat: @"PropTable = \"%@\"\r\n", PropTable];
    
    return JSONAutoRelease(descriptionOutput);
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[Code release];
	[Msg release];
	[BrandTitle release];
	[Pics release];
	[Title release];
	[OurPrice release];
	[MarketPrice release];
	[SaleTip release];
	[SizeTablePic release];
	[ExtraInfo release];
	[MoreDetail release];
	[SoldOut release];
	[ColorPropName release];
	[ColorInfo release];
	[SizePropName release];
	[SizeInfo release];
	[IsFaved release];
	[PropTable release];
    
    [super dealloc];
#endif
}

@end
