//
//  DescribeVO.m
//  YingMeiHui
//
//  Created by work on 15-1-6.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "DescribeVO.h"

@implementation DescribeVO

@synthesize source_id;
@synthesize source_platform;
@synthesize title;
@synthesize short_title;
@synthesize sub_title;
@synthesize promo_word;
@synthesize sales_price;
@synthesize market_price;
@synthesize is_buy_change;
@synthesize click_url;
@synthesize free_postage;
@synthesize image;
@synthesize image2;
@synthesize taobao_images;
@synthesize taobao_month_orders;
@synthesize editor_comment;
@synthesize fav_num;

+ (DescribeVO *)DescribeVOWithDictionary:(NSDictionary *)dictionary{
    DescribeVO *instance = [[DescribeVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"source_id"] && ![[dictionary objectForKey:@"source_id"] isEqual:[NSNull null]]) {
            self.source_id = [dictionary objectForKey:@"source_id"];
        }
        
        if (nil != [dictionary objectForKey:@"source_platform"] && ![[dictionary objectForKey:@"source_platform"] isEqual:[NSNull null]]) {
            self.source_platform = [dictionary objectForKey:@"source_platform"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"sub_title"] && ![[dictionary objectForKey:@"sub_title"] isEqual:[NSNull null]]) {
            self.sub_title = [dictionary objectForKey:@"sub_title"];
        }
        
        if (nil != [dictionary objectForKey:@"short_title"] && ![[dictionary objectForKey:@"short_title"] isEqual:[NSNull null]]) {
            self.short_title = [dictionary objectForKey:@"short_title"];
        }
        
        if (nil != [dictionary objectForKey:@"promo_word"] && ![[dictionary objectForKey:@"promo_word"] isEqual:[NSNull null]]) {
            self.promo_word = [dictionary objectForKey:@"promo_word"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_price"] && ![[dictionary objectForKey:@"sales_price"] isEqual:[NSNull null]]) {
            self.sales_price = [dictionary objectForKey:@"sales_price"];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.market_price = [dictionary objectForKey:@"market_price"];
        }
        
        if (nil != [dictionary objectForKey:@"is_buy_change"] && ![[dictionary objectForKey:@"is_buy_change"] isEqual:[NSNull null]]) {
            self.is_buy_change = [dictionary objectForKey:@"is_buy_change"];
        }
        
        if (nil != [dictionary objectForKey:@"click_url"] && ![[dictionary objectForKey:@"click_url"] isEqual:[NSNull null]]) {
            self.click_url = [dictionary objectForKey:@"click_url"];
        }
        
        if (nil != [dictionary objectForKey:@"free_postage"] && ![[dictionary objectForKey:@"free_postage"] isEqual:[NSNull null]]) {
            self.free_postage = [dictionary objectForKey:@"free_postage"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"image2"] && ![[dictionary objectForKey:@"image2"] isEqual:[NSNull null]]) {
            self.image2 = [dictionary objectForKey:@"image2"];
        }
        
        if (nil != [dictionary objectForKey:@"taobao_images"] && ![[dictionary objectForKey:@"taobao_images"] isEqual:[NSNull null]]) {
            self.taobao_images = [dictionary objectForKey:@"taobao_images"];
        }
        
        if (nil != [dictionary objectForKey:@"taobao_month_orders"] && ![[dictionary objectForKey:@"taobao_month_orders"] isEqual:[NSNull null]]) {
            self.taobao_month_orders = [dictionary objectForKey:@"taobao_month_orders"];
        }
        if (nil != [dictionary objectForKey:@"editor_comment"] && ![[dictionary objectForKey:@"editor_comment"] isEqual:[NSNull null]]) {
            self.editor_comment = [dictionary objectForKey:@"editor_comment"];
        }
        if (nil != [dictionary objectForKey:@"fav_num"] && ![[dictionary objectForKey:@"fav_num"] isEqual:[NSNull null]]) {
            self.fav_num = [dictionary objectForKey:@"fav_num"];
        }
    }
    
    return self;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [code release];
    [msg release];
    
    [super dealloc];
#endif
}
@end
