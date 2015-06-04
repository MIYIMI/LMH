//
//  LMH_EventVO.m
//  YingMeiHui
//
//  Created by work on 15/5/29.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMH_EventVO.h"
#import "HomeVO.h"

@implementation LMH_EventVO

@synthesize share_content;
@synthesize  click_url;
@synthesize  title;
@synthesize  evaluate_list;
@synthesize  evaluate_count;
@synthesize  fav_img;
@synthesize  fav_count;
@synthesize  fav;
@synthesize  recommend_goods;
@synthesize  goods;
@synthesize  image;
@synthesize  banner_img;
@synthesize  text_words;
@synthesize  topic_ios;
@synthesize  buyer_url;

+ (NSArray *)LMH_EventVOListWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMH_EventVO LMH_EventVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (LMH_EventVO  *)LMH_EventVOWithDictionary:(NSDictionary *)dictionary{
    LMH_EventVO *instance = [[LMH_EventVO alloc] initWithDictionary:dictionary];
    
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != dictionary[@"click_url"] && ![dictionary[@"click_url"] isEqual:[NSNull null]]) {
            self.click_url = dictionary[@"click_url"];
        }
        
        if (nil != dictionary[@"title"] && ![dictionary[@"title"] isEqual:[NSNull null]]) {
            self.title = dictionary[@"title"];
        }
        
        if (nil != dictionary[@"evaluate_data"][@"evaluate_list"] && ![dictionary[@"evaluate_data"][@"evaluate_list"] isEqual:[NSNull null]] && [dictionary[@"evaluate_data"][@"evaluate_list"] isKindOfClass:[NSArray class]]) {
            self.evaluate_list = [LMH_EvaluatedVO LMH_EvaluatedVOListWithArray:dictionary[@"evaluate_data"][@"evaluate_list"]];
        }
        
        if (nil != dictionary[@"evaluate_data"][@"evaluate_count"] && ![dictionary[@"evaluate_data"][@"evaluate_count"] isEqual:[NSNull null]]) {
            self.evaluate_count = dictionary[@"evaluate_data"][@"evaluate_count"];
        }
        
        if (nil != dictionary[@"fav_data"][@"fav_img"] && ![dictionary[@"fav_data"][@"fav_img"] isEqual:[NSNull null]] && [dictionary[@"fav_data"][@"fav_img"] isKindOfClass:[NSArray class]]) {
            self.fav_img = dictionary[@"fav_data"][@"fav_img"];
        }
        
        if (nil != dictionary[@"fav_data"][@"fav_count"] && ![dictionary[@"fav_data"][@"fav_count"] isEqual:[NSNull null]]) {
            self.fav_count = dictionary[@"fav_data"][@"fav_count"];
        }
        
        if (nil != dictionary[@"fav"] && ![dictionary[@"fav"] isEqual:[NSNull null]]) {
            self.fav = dictionary[@"fav"];
        }
        
        if (nil != dictionary[@"recommend_goods"] && ![dictionary[@"recommend_goods"] isEqual:[NSNull null]] && [dictionary[@"recommend_goods"] isKindOfClass:[NSArray class]]) {
            self.recommend_goods = [HomeProductVO HomeProductVOListWithArray:dictionary[@"recommend_goods"]];
        }
        
        if (nil != dictionary[@"goods"] && ![dictionary[@"goods"] isEqual:[NSNull null]] && [dictionary[@"goods"] isKindOfClass:[NSArray class]]) {
            self.goods = [HomeProductVO HomeProductVOListWithArray:dictionary[@"goods"]];
        }
        
        if (nil != dictionary[@"image"] && ![dictionary[@"image"] isEqual:[NSNull null]]) {
            self.image = dictionary[@"image"];
        }
        
        if (nil != dictionary[@"banner_img"] && ![dictionary[@"banner_img"] isEqual:[NSNull null]]) {
            self.banner_img = dictionary[@"banner_img"];
        }
        
        if (nil != dictionary[@"text_words"] && ![dictionary[@"text_words"] isEqual:[NSNull null]]) {
            self.text_words = dictionary[@"text_words"];
        }
        
        if (nil != dictionary[@"topic_ios"] && ![dictionary[@"topic_ios"] isEqual:[NSNull null]]) {
            self.topic_ios = dictionary[@"topic_ios"];
        }
        
        if (nil != dictionary[@"buyer_url"] && ![dictionary[@"buyer_url"] isEqual:[NSNull null]]) {
            self.buyer_url = dictionary[@"buyer_url"];
        }
    }
    
    return self;
}

@end



@implementation LMH_EvaluatedVO : NSObject

@synthesize evaluaid;
@synthesize content;
@synthesize nickname;
@synthesize reply_user_id;
@synthesize reply_nickname;
@synthesize create_at;
@synthesize fav_count;
@synthesize fav;
@synthesize avatar;

+ (NSArray *)LMH_EvaluatedVOListWithArray:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMH_EvaluatedVO LMH_EvaluatedVOWithDictionary:entry]];
    }
    
    return resultsArray;

}

+ (LMH_EvaluatedVO  *)LMH_EvaluatedVOWithDictionary:(NSDictionary *)dictionary{
    LMH_EvaluatedVO *instance = [[LMH_EvaluatedVO alloc] initWithDictionary:dictionary];
    
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != dictionary[@"id"] && ![dictionary[@"id"] isEqual:[NSNull null]]) {
            self.evaluaid = dictionary[@"id"];
        }
        
        if (nil != dictionary[@"content"] && ![dictionary[@"content"] isEqual:[NSNull null]]) {
            self.content = dictionary[@"content"];
        }
        
        if (nil != dictionary[@"nickname"] && ![dictionary[@"nickname"] isEqual:[NSNull null]]) {
            self.nickname = dictionary[@"nickname"];
        }
        
        if (nil != dictionary[@"reply_user_id"] && ![dictionary[@"reply_user_id"] isEqual:[NSNull null]]) {
            self.reply_user_id = dictionary[@"reply_user_id"];
        }
        
        if (nil != dictionary[@"reply_nickname"] && ![dictionary[@"reply_nickname"] isEqual:[NSNull null]]) {
            self.reply_nickname = dictionary[@"reply_nickname"];
        }
        
        if (nil != dictionary[@"create_at"] && ![dictionary[@"create_at"] isEqual:[NSNull null]]) {
            self.create_at = dictionary[@"create_at"];
        }
        
        if (nil != dictionary[@"fav_count"] && ![dictionary[@"fav_count"] isEqual:[NSNull null]]) {
            self.fav_count = dictionary[@"fav_count"];
        }
        
        if (nil != dictionary[@"fav"] && ![dictionary[@"fav"] isEqual:[NSNull null]]) {
            self.fav = dictionary[@"fav"];
        }
        
        if (nil != dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
            self.avatar = dictionary[@"avatar"];
        }
    }
    
    return self;
}

@end
