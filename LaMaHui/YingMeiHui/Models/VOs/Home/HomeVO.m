//
//  HomeVO.m
//  YingMeiHui
//
//  Created by work on 14-11-10.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "HomeVO.h"
#import "LimitedSeckillVO.h"

//首页主体数据
@implementation HomeVO
@synthesize sell_time;
@synthesize activity;
@synthesize seckill_list;
@synthesize wap_ad_list;
@synthesize event_list;
@synthesize event_goods;
@synthesize product_hot_list;
@synthesize productlist;
@synthesize banner;
@synthesize category_list;
@synthesize total_count;
@synthesize brandBanner;
@synthesize app_cache_secret;
@synthesize class_list;
@synthesize campaign_list;

+ (HomeVO *)HomeVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [HomeVO HomeVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (NSArray *)HomeVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[HomeVO HomeVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (HomeVO *)HomeVOWithDictionary:(NSDictionary *)dictionary
{
    HomeVO *instance = [[HomeVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"sell_time_to"] && ![[dictionary objectForKey:@"sell_time_to"] isEqual:[NSNull null]]) {
            self.sell_time = [dictionary objectForKey:@"sell_time_to"];
        }
        
        if (nil != [dictionary objectForKey:@"activity"] && ![[dictionary objectForKey:@"activity"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"activity"] isKindOfClass:[NSArray class]]) {
            self.activity = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"activity"]];
        }else if (nil != [dictionary objectForKey:@"activity_pics"] && ![[dictionary objectForKey:@"activity_pics"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"activity_pics"] isKindOfClass:[NSArray class]]) {
            self.activity = [HomeActivityVO HomeActivityVOListWithArray:[dictionary objectForKey:@"activity_pics"]];
        }
        
        if (nil != [dictionary objectForKey:@"seckill_list"] && ![[dictionary objectForKey:@"seckill_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"seckill_list"] isKindOfClass:[NSArray class]]) {
            self.seckill_list = [LimitedSeckillVO LimitedSeckillVOListWithArray:[dictionary objectForKey:@"seckill_list"]];
        }
        
        //   首页滚动图标
        if (nil != [dictionary objectForKey:@"wap_ad_list"] && ![[dictionary objectForKey:@"wap_ad_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"wap_ad_list"] isKindOfClass:[NSArray class]]) {
            self.wap_ad_list = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"wap_ad_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"event_list"] && ![[dictionary objectForKey:@"event_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"event_list"] isKindOfClass:[NSArray class]]) {
            self.event_list = [HomeBrandVO HomeBrandVOListWithArray:[dictionary objectForKey:@"event_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"event_goods"] && ![[dictionary objectForKey:@"event_goods"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"event_goods"] isKindOfClass:[NSArray class]]) {
            self.event_goods = [HomeBrandVO HomeBrandVOListWithArray:[dictionary objectForKey:@"event_goods"]];
        }
        
        if (nil != [dictionary objectForKey:@"product_hot_list"] && ![[dictionary objectForKey:@"product_hot_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_hot_list"] isKindOfClass:[NSArray class]]) {
            self.product_hot_list = [HomeProductVO HomeProductVOListWithArray:[dictionary objectForKey:@"product_hot_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"productlist"] && ![[dictionary objectForKey:@"productlist"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"productlist"] isKindOfClass:[NSArray class]]) {
            self.productlist = [HomeProductVO HomeProductVOListWithArray:[dictionary objectForKey:@"productlist"]];
        }
        
        if (nil != [dictionary objectForKey:@"banner"] && ![[dictionary objectForKey:@"banner"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"banner"] isKindOfClass:[NSArray class]]) {
            self.banner = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"banner"]];
        }
        
        if (nil != [dictionary objectForKey:@"category_list"] && ![[dictionary objectForKey:@"category_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"category_list"] isKindOfClass:[NSArray class]]) {
            self.category_list = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"category_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"total_count"] && ![[dictionary objectForKey:@"total_count"] isEqual:[NSNull null]]) {
            self.total_count = [dictionary objectForKey:@"total_count"];
        }
        
        if (nil != [dictionary objectForKey:@"brandbanner"] && ![[dictionary objectForKey:@"brandbanner"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"brandbanner"] isKindOfClass:[NSString class]]) {
            self.brandBanner = [dictionary objectForKey:@"brandbanner"];
        }
        if (nil != [dictionary objectForKey:@"productlist_name"] && ![[dictionary objectForKey:@"productlist_name"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"productlist_name"] isKindOfClass:[NSString class]]) {
            self.productlist_name = [dictionary objectForKey:@"productlist_name"];
        }
        if (nil != [dictionary objectForKey:@"app_cache_secret"] && ![[dictionary objectForKey:@"app_cache_secret"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"app_cache_secret"] isKindOfClass:[NSString class]]) {
            self.app_cache_secret = [dictionary objectForKey:@"app_cache_secret"];
        }
        
        if (nil != [dictionary objectForKey:@"class_list"] && ![[dictionary objectForKey:@"class_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"class_list"] isKindOfClass:[NSArray class]]) {
            self.class_list = [FiterVO FiterVOListWithArray:[dictionary objectForKey:@"class_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"campaign_list"] && ![[dictionary objectForKey:@"campaign_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"campaign_list"] isKindOfClass:[NSArray class]]) {
            self.campaign_list = [CampaignVO CampaignVOListWithArray:[dictionary objectForKey:@"campaign_list"]];
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


//首页活动
@implementation HomeActivityVO
@synthesize imgeUrl;
@synthesize destID;
@synthesize title;
@synthesize Key;

+ (NSArray *)HomeActivityVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[HomeActivityVO HomeActivityVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (HomeActivityVO *)HomeActivityVOWithDictionary:(NSDictionary *)dictionary
{
    HomeActivityVO *instance = [[HomeActivityVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]) {
            self.imgeUrl = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"url"] && ![[dictionary objectForKey:@"url"] isEqual:[NSNull null]] ) {
            self.destID = [dictionary objectForKey:@"url"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]] ) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"key"] && ![[dictionary objectForKey:@"key"] isEqual:[NSNull null]] ) {
            self.Key = [dictionary objectForKey:@"key"];
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


//首页品牌活动
@implementation HomeBrandVO
@synthesize Title;
@synthesize postion;
@synthesize brandArray;

+ (NSArray *)HomeBrandVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[HomeBrandVO HomeBrandVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (HomeBrandVO *)HomeBrandVOWithDictionary:(NSDictionary *)dictionary
{
    HomeBrandVO *instance = [[HomeBrandVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.Title = [dictionary objectForKey:@"title"];
        }
        if (nil != [dictionary objectForKey:@"postion"] && ![[dictionary objectForKey:@"postion"] isEqual:[NSNull null]]) {
            self.postion = [dictionary objectForKey:@"postion"];
        }
        
        if (nil != [dictionary objectForKey:@"brand"] && ![[dictionary objectForKey:@"brand"] isEqual:[NSNull null]]  && [[dictionary objectForKey:@"brand"] isKindOfClass:[NSArray class]]) {
            self.brandArray = [AdvVO AdvVOListWithArray:[dictionary objectForKey:@"brand"]];
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


//首页商品列表数据
@implementation HomeProductVO
@synthesize product_id;
@synthesize product_name;
@synthesize begin_time;
@synthesize age_group;
@synthesize pic;
@synthesize our_price;
@synthesize market_price;
@synthesize sale_tip;
@synthesize detail_label;
@synthesize final_price;
@synthesize sold_out;
@synthesize sales_num;
@synthesize product_status;
@synthesize exclusive_price;
@synthesize is_exclusive;
@synthesize sales_title;
@synthesize brand_id;
@synthesize brand_title;
@synthesize stock;
@synthesize product_tags;
@synthesize click_url;
@synthesize source_platform;
@synthesize logo;
@synthesize is_check;
@synthesize is_buy_change;
@synthesize free_postage;
@synthesize is_boutique;
@synthesize source_platform_cn;

@synthesize age;
@synthesize tag_url;

+ (NSArray *)HomeProductVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[HomeProductVO HomeProductVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (HomeProductVO *)HomeProductVOWithDictionary:(NSDictionary *)dictionary
{
    HomeProductVO *instance = [[HomeProductVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"product_id"] && ![[dictionary objectForKey:@"product_id"] isEqual:[NSNull null]]) {
            self.product_id = [dictionary objectForKey:@"product_id"];
        }
        
        if (nil != [dictionary objectForKey:@"product_name"] && ![[dictionary objectForKey:@"product_name"] isEqual:[NSNull null]]) {
            self.product_name = [dictionary objectForKey:@"product_name"];
        }else if(nil != dictionary[@"title"] && ![dictionary[@"title"] isEqual:[NSNull null]]){
            self.product_name = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"age_group"] && ![[dictionary objectForKey:@"age_group"] isEqual:[NSNull null]]) {
            self.age_group = [dictionary objectForKey:@"age_group"];
        }
        
        if (nil != [dictionary objectForKey:@"begin_time"] && ![[dictionary objectForKey:@"begin_time"] isEqual:[NSNull null]]) {
            self.begin_time = [dictionary objectForKey:@"begin_time"];
        }
        
        if (nil != [dictionary objectForKey:@"pic"] && ![[dictionary objectForKey:@"pic"] isEqual:[NSNull null]]) {
            self.pic = [dictionary objectForKey:@"pic"];
        }else if(nil != dictionary[@"image"] && ![dictionary[@"image"] isEqual:[NSNull null]]){
            self.pic = [dictionary objectForKey:@"image"];
        }else if(nil != dictionary[@"img"] && ![dictionary[@"img"] isEqual:[NSNull null]]){
            self.pic = [dictionary objectForKey:@"img"];
        }
        
        if (nil != [dictionary objectForKey:@"our_price"] && ![[dictionary objectForKey:@"our_price"] isEqual:[NSNull null]]) {
            self.our_price = [dictionary objectForKey:@"our_price"];
        }else if(nil != dictionary[@"sales_price"] && ![dictionary[@"sales_price"] isEqual:[NSNull null]]){
            self.our_price = [NSNumber numberWithFloat:[dictionary[@"sales_price"] floatValue]];
        }
        
        if (nil != [dictionary objectForKey:@"market_price"] && ![[dictionary objectForKey:@"market_price"] isEqual:[NSNull null]]) {
            self.market_price = [dictionary objectForKey:@"market_price"];
        }

        if (nil != [dictionary objectForKey:@"sale_tip"] && ![[dictionary objectForKey:@"sale_tip"] isEqual:[NSNull null]]) {
            self.sale_tip = [dictionary objectForKey:@"sale_tip"];
        }
        
        if (nil != [dictionary objectForKey:@"detail_label"] && ![[dictionary objectForKey:@"detail_label"] isEqual:[NSNull null]]) {
            self.detail_label = [dictionary objectForKey:@"detail_label"];
        }
        
        if (nil != [dictionary objectForKey:@"final_price"] && ![[dictionary objectForKey:@"final_price"] isEqual:[NSNull null]]) {
            self.final_price = [dictionary objectForKey:@"final_price"];
        }

        if (nil != [dictionary objectForKey:@"sold_out"] && ![[dictionary objectForKey:@"sold_out"] isEqual:[NSNull null]]) {
            self.sold_out = [dictionary objectForKey:@"sold_out"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_num"] && ![[dictionary objectForKey:@"sales_num"] isEqual:[NSNull null]]) {
            self.sales_num = [dictionary objectForKey:@"sales_num"];
        }
        
        if (nil != [dictionary objectForKey:@"product_status"] && ![[dictionary objectForKey:@"product_status"] isEqual:[NSNull null]]) {
            self.product_status = [dictionary objectForKey:@"product_status"];
        }
        
        if (nil != [dictionary objectForKey:@"exclusive_price"] && ![[dictionary objectForKey:@"exclusive_price"] isEqual:[NSNull null]]) {
            self.exclusive_price = [dictionary objectForKey:@"exclusive_price"];
        }
        
        if (nil != [dictionary objectForKey:@"is_exclusive"] && ![[dictionary objectForKey:@"is_exclusive"] isEqual:[NSNull null]]) {
            self.is_exclusive = [dictionary objectForKey:@"is_exclusive"];
        }
        
        if (nil != [dictionary objectForKey:@"sales_title"] && ![[dictionary objectForKey:@"sales_title"] isEqual:[NSNull null]]) {
            self.sales_title = [dictionary objectForKey:@"sales_title"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_id"] && ![[dictionary objectForKey:@"brand_id"] isEqual:[NSNull null]]) {
            self.brand_id = [dictionary objectForKey:@"brand_id"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_title"] && ![[dictionary objectForKey:@"brand_title"] isEqual:[NSNull null]]) {
            self.brand_title = [dictionary objectForKey:@"brand_title"];
        }
        
        if (nil != [dictionary objectForKey:@"stock"] && ![[dictionary objectForKey:@"stock"] isEqual:[NSNull null]]) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        if (nil != [dictionary objectForKey:@"product_tags"] && ![[dictionary objectForKey:@"product_tags"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"product_tags"] isKindOfClass:[NSArray class]]) {
            self.product_tags = [dictionary objectForKey:@"product_tags"];
        }
        
        if (nil != [dictionary objectForKey:@"click_url"] && ![[dictionary objectForKey:@"click_url"] isEqual:[NSNull null]]) {
            self.click_url = [dictionary objectForKey:@"click_url"];
        }
        
        if (nil != [dictionary objectForKey:@"source_platform"] && ![[dictionary objectForKey:@"source_platform"] isEqual:[NSNull null]]) {
            self.source_platform = [dictionary objectForKey:@"source_platform"];
        }
        if (nil != [dictionary objectForKey:@"logo"] && ![[dictionary objectForKey:@"logo"] isEqual:[NSNull null]]) {
            self.logo = [dictionary objectForKey:@"logo"];
        }
        if (nil != [dictionary objectForKey:@"is_buy_change"] && ![[dictionary objectForKey:@"is_buy_change"] isEqual:[NSNull null]]) {
            self.is_buy_change = [dictionary objectForKey:@"is_buy_change"];
        }
        if (nil != [dictionary objectForKey:@"free_postage"] && ![[dictionary objectForKey:@"free_postage"] isEqual:[NSNull null]]) {
            self.free_postage = [dictionary objectForKey:@"free_postage"];
        }
        if (nil != [dictionary objectForKey:@"is_check"] && ![[dictionary objectForKey:@"is_check"] isEqual:[NSNull null]]) {
            self.is_check = [dictionary objectForKey:@"is_check"];
        }
        if (nil != [dictionary objectForKey:@"is_boutique"] && ![[dictionary objectForKey:@"is_boutique"] isEqual:[NSNull null]]) {
            self.is_boutique = [dictionary objectForKey:@"is_boutique"];
        }
        if (nil != [dictionary objectForKey:@"source_platform_cn"] && ![[dictionary objectForKey:@"source_platform_cn"] isEqual:[NSNull null]]) {
            self.source_platform_cn = [dictionary objectForKey:@"source_platform_cn"];
        }
        if (nil != [dictionary objectForKey:@"is_activity"] && ![[dictionary objectForKey:@"is_activity"] isEqual:[NSNull null]]) {
            self.is_activity = [dictionary objectForKey:@"is_activity"];
        }
        if (nil != [dictionary objectForKey:@"activity_type"] && ![[dictionary objectForKey:@"activity_type"] isEqual:[NSNull null]]) {
            self.activity_type = [dictionary objectForKey:@"activity_type"];
        }
        if (nil != [dictionary objectForKey:@"activity_key"] && ![[dictionary objectForKey:@"activity_key"] isEqual:[NSNull null]]) {
            self.activity_key = [dictionary objectForKey:@"activity_key"];
        }
        if (nil != [dictionary objectForKey:@"activity_image_w"] && ![[dictionary objectForKey:@"activity_image_w"] isEqual:[NSNull null]]) {
            self.activity_image_w = [dictionary objectForKey:@"activity_image_w"];
        }
        if (nil != [dictionary objectForKey:@"activity_image_h"] && ![[dictionary objectForKey:@"activity_image_h"] isEqual:[NSNull null]]) {
            self.activity_image_h = [dictionary objectForKey:@"activity_image_h"];
        }
        
        if(nil != dictionary[@"age"] && ![dictionary[@"age"] isEqual:[NSNull null]]){
            self.age = [dictionary objectForKey:@"age"];
        }else if(nil != dictionary[@"intended_population"] && ![dictionary[@"intended_population"] isEqual:[NSNull null]]){
            self.age = [dictionary objectForKey:@"intended_population"];
        }
        
        if(nil != dictionary[@"tag_url"] && ![dictionary[@"tag_url"] isEqual:[NSNull null]]){
            self.tag_url = [dictionary objectForKey:@"tag_url"];
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

@implementation FiterVO
@synthesize name;
@synthesize list_name;
@synthesize list_array;

+ (NSArray *)FiterVOListWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[FiterVO FiterVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (FiterVO *)FiterVOWithDictionary:(NSDictionary *)dictionary{
    FiterVO *instance = [[FiterVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}


- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        NSString *listName = [NSString stringWithFormat:@"%@_list_name", self.name];
        if (nil != [dictionary objectForKey:listName] && ![[dictionary objectForKey:listName] isEqual:[NSNull null]]) {
            self.list_name = [dictionary objectForKey:listName];
        }
        
        NSString *arrayName = [NSString stringWithFormat:@"%@_list",self.name];
        if (nil != [dictionary objectForKey:arrayName] && ![[dictionary objectForKey:arrayName] isEqual:[NSNull null]] && [[dictionary objectForKey:arrayName] isKindOfClass:[NSArray class]]) {
            self.list_array = [FiterSonVO FiterSonVOListWithArray:[dictionary objectForKey:arrayName] withName:self.name];
        }
    }
    
    return self;
}

@end

@implementation FiterSonVO
@synthesize id_name;
@synthesize title;
@synthesize list_id;
@synthesize pid;
@synthesize list_son;
@synthesize is_chcek;

+ (NSArray *)FiterSonVOListWithArray:(NSArray *)array withName:(NSString *)name{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[FiterSonVO FiterSonVOWithDictionary:entry withName:name]];
    }
    
    return JSONAutoRelease(resultsArray);
}

+ (FiterSonVO *)FiterSonVOWithDictionary:(NSDictionary *)dictionary withName:(NSString *)name{
    FiterSonVO *instance = [[FiterSonVO alloc] initWithDictionary:dictionary withName:name];
    return JSONAutoRelease(instance);
}


- (id)initWithDictionary:(NSDictionary *)dictionary withName:(NSString *)name{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        NSString *idName = [NSString stringWithFormat:@"%@_list_id", name];
        if (nil != [dictionary objectForKey:idName] && ![[dictionary objectForKey:idName] isEqual:[NSNull null]]) {
            self.list_id = [dictionary objectForKey:idName];
        }
        self.id_name = idName;
        
        NSString *sonName = [NSString stringWithFormat:@"%@_list_son",name];
        if (nil != [dictionary objectForKey:sonName] && ![[dictionary objectForKey:sonName] isEqual:[NSNull null]] && [[dictionary objectForKey:sonName] isKindOfClass:[NSArray class]]) {
            self.list_son = [FiterSonVO FiterSonVOListWithArray:[dictionary objectForKey:sonName] withName:name];
        }
        
        if (nil != [dictionary objectForKey:@"pid"] && ![[dictionary objectForKey:@"pid"] isEqual:[NSNull null]]) {
            self.pid = [dictionary objectForKey:@"pid"];
        }
        
        if (nil != [dictionary objectForKey:@"is_check"] && ![[dictionary objectForKey:@"is_check"] isEqual:[NSNull null]]) {
            self.is_chcek = [dictionary objectForKey:@"is_check"];
        }
    }
    
    return self;
}

@end

//专场数据
@implementation CampaignVO
@synthesize comment_count;
@synthesize campaign_goods_list;
@synthesize topic_ios;
@synthesize buyer_img;
@synthesize campaign_name;
@synthesize campaign_goods_count;
@synthesize buyer_url;
@synthesize campaign_id;
@synthesize topic_title;
@synthesize title;
@synthesize weixin;
@synthesize like_count;
@synthesize buyer;
@synthesize brand_logo;
@synthesize weixin_text;

+ (NSArray *)CampaignVOListWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[CampaignVO CampaignVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (CampaignVO *)CampaignVOWithDictionary:(NSDictionary *)dictionary{
    CampaignVO *instance = [[CampaignVO alloc] initWithDictionary:dictionary];
    
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"comment_count"] && ![[dictionary objectForKey:@"comment_count"] isEqual:[NSNull null]]) {
            self.comment_count = [dictionary objectForKey:@"comment_count"];
        }
        
        if (nil != [dictionary objectForKey:@"campaign_goods_list"] && ![[dictionary objectForKey:@"campaign_goods_list"] isEqual:[NSNull null]] && [[dictionary objectForKey:@"campaign_goods_list"] isKindOfClass:[NSArray class]]) {
            self.campaign_goods_list = [HomeProductVO HomeProductVOListWithArray:[dictionary objectForKey:@"campaign_goods_list"]];
        }
        
        if (nil != [dictionary objectForKey:@"topic_ios"] && ![[dictionary objectForKey:@"topic_ios"] isEqual:[NSNull null]]) {
            self.topic_ios = [dictionary objectForKey:@"topic_ios"];
        }
        
        if (nil != [dictionary objectForKey:@"buyer_img"] && ![[dictionary objectForKey:@"buyer_img"] isEqual:[NSNull null]]) {
            self.buyer_img = [dictionary objectForKey:@"buyer_img"];
        }
        
        if (nil != [dictionary objectForKey:@"campaign_name"] && ![[dictionary objectForKey:@"campaign_name"] isEqual:[NSNull null]]) {
            self.campaign_name = [dictionary objectForKey:@"campaign_name"];
        }
        
        if (nil != [dictionary objectForKey:@"campaign_goods_count"] && ![[dictionary objectForKey:@"campaign_goods_count"] isEqual:[NSNull null]]) {
            self.campaign_goods_count = [dictionary objectForKey:@"campaign_goods_count"];
        }
        
        if (nil != [dictionary objectForKey:@"buyer_url"] && ![[dictionary objectForKey:@"buyer_url"] isEqual:[NSNull null]]) {
            self.buyer_url = [dictionary objectForKey:@"buyer_url"];
        }
        
        if (nil != [dictionary objectForKey:@"campaign_id"] && ![[dictionary objectForKey:@"campaign_id"] isEqual:[NSNull null]]) {
            self.campaign_id = [dictionary objectForKey:@"campaign_id"];
        }
        
        if (nil != [dictionary objectForKey:@"topic_title"] && ![[dictionary objectForKey:@"topic_title"] isEqual:[NSNull null]]) {
            self.topic_title = [dictionary objectForKey:@"topic_title"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"weixin"] && ![[dictionary objectForKey:@"weixin"] isEqual:[NSNull null]]) {
            self.weixin = [dictionary objectForKey:@"weixin"];
        }
        
        if (nil != [dictionary objectForKey:@"like_count"] && ![[dictionary objectForKey:@"like_count"] isEqual:[NSNull null]]) {
            self.like_count = [dictionary objectForKey:@"like_count"];
        }
        
        if (nil != [dictionary objectForKey:@"buyer"] && ![[dictionary objectForKey:@"buyer"] isEqual:[NSNull null]]) {
            self.buyer = [dictionary objectForKey:@"buyer"];
        }
        
        if (nil != [dictionary objectForKey:@"brand_logo"] && ![[dictionary objectForKey:@"brand_logo"] isEqual:[NSNull null]]) {
            self.brand_logo = [dictionary objectForKey:@"brand_logo"];
        }
        
        if (nil != [dictionary objectForKey:@"weixin_text"] && ![[dictionary objectForKey:@"weixin_text"] isEqual:[NSNull null]]) {
            self.weixin_text = [dictionary objectForKey:@"weixin_text"];
        }
    }
    
    return self;

}

@end


