//
//  LMHMyCommentVO.m
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "LMHMyCommentVO.h"

@implementation LMHMyCommentVO

@synthesize evaluate_id;
@synthesize content;
@synthesize create_at;
@synthesize avatar;
@synthesize nickname;
@synthesize goods_infor;

+ (LMHMyCommentVO *)LMHMyCommentVOWithDictionary:(NSDictionary *)dictionary
{
    LMHMyCommentVO *instance = [[LMHMyCommentVO alloc] initWithDictionary:dictionary];
    return instance;
}

+ (NSArray *)LMHMyCommentVOListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMHMyCommentVO LMHMyCommentVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"evaluate_id"] && ![[dictionary objectForKey:@"evaluate_id"] isEqual:[NSNull null]]) {
            self.evaluate_id = [dictionary objectForKey:@"evaluate_id"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"create_at"] && ![[dictionary objectForKey:@"create_at"] isEqual:[NSNull null]]) {
            self.create_at = [dictionary objectForKey:@"create_at"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]) {
            self.nickname = [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"goods_infor"] && ![[dictionary objectForKey:@"goods_infor"] isEqual:[NSNull null]]) {

            self.goods_infor = [LMHMyCommentInfoVO LMHMyCommentInfoVOWithDictionary:[dictionary objectForKey:@"goods_infor"]];
        }
        
    }
    
    return self;
}

@end


@implementation LMHMyCommentInfoVO
@synthesize img;
@synthesize title;
@synthesize type;
@synthesize goodsInfoid;
@synthesize name;
@synthesize buyer_url;

+ (LMHMyCommentInfoVO *)LMHMyCommentInfoVOWithDictionary:(NSDictionary *)dictionary
{
    LMHMyCommentInfoVO *instance = [[LMHMyCommentInfoVO alloc] initWithDictionaryInfo:dictionary];
    return instance;
}

+ (NSArray *)LMHMyCommentVOInfoListWithArray:(NSArray *)array
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMHMyCommentInfoVO LMHMyCommentInfoVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

- (id)initWithDictionaryInfo:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"img"] && ![[dictionary objectForKey:@"img"] isEqual:[NSNull null]]) {
            self.img = [dictionary objectForKey:@"img"];
        }
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        if (nil != [dictionary objectForKey:@"id"] && ![[dictionary objectForKey:@"id"] isEqual:[NSNull null]]) {
            self.goodsInfoid = [dictionary objectForKey:@"id"];
        }
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        if (nil != dictionary[@"weixin"] && ![dictionary[@"weixin"] isEqual:[NSNull null]]) {
            self.weixin = dictionary[@"weixin"];
        }
        if (nil != dictionary[@"buyer_url"] && ![dictionary[@"buyer_url"] isEqual:[NSNull null]]) {
            self.buyer_url = dictionary[@"buyer_url"];
        }
    }
    
    return self;
}
@end