//
//  LMH_EventVO.h
//  YingMeiHui
//
//  Created by work on 15/5/29.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMH_EventVO : NSObject

+ (LMH_EventVO  *)LMH_EventVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMH_EventVOListWithArray:(NSArray *)array;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic,strong)NSString *click_url;
@property(nonatomic,strong)NSString *share_content;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSArray *evaluate_list;
@property(nonatomic,strong)NSNumber *evaluate_count;
@property(nonatomic,strong)NSArray *fav_img;
@property(nonatomic,strong)NSNumber *fav_count;
@property(nonatomic,strong)NSNumber *fav;
@property(nonatomic,strong)NSArray *recommend_goods;
@property(nonatomic,strong)NSArray *goods;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *banner_img;
@property(nonatomic,strong)NSString *text_words;
@property(nonatomic,strong)NSString *topic_ios;
@property(nonatomic,strong)NSString *buyer_url;

@end

@interface LMH_EvaluatedVO : NSObject

+ (LMH_EvaluatedVO  *)LMH_EvaluatedVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMH_EvaluatedVOListWithArray:(NSArray *)array;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic,strong)NSNumber *evaluaid;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSNumber *reply_user_id;
@property(nonatomic,strong)NSString *reply_nickname;
@property(nonatomic,strong)NSString *create_at;
@property(nonatomic,strong)NSNumber *fav_count;
@property(nonatomic,strong)NSNumber *fav;
@property(nonatomic,strong)NSString *avatar;

@end