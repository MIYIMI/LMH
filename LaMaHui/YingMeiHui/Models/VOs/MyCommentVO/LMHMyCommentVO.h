//
//  LMHMyCommentVO.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-5-27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMHMyCommentInfoVO;

@interface LMHMyCommentVO : NSObject

+ (LMHMyCommentVO *)LMHMyCommentVOWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)LMHMyCommentVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic,strong)NSNumber *evaluate_id;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *create_at;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)LMHMyCommentInfoVO  *goods_infor;

@end



@interface LMHMyCommentInfoVO : NSObject

+ (LMHMyCommentInfoVO *)LMHMyCommentInfoVOWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)LMHMyCommentVOInfoListWithArray:(NSArray *)array;

- (id)initWithDictionaryInfo:(NSDictionary *)dictionary;

@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSNumber *goodsInfoid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *weixin;
@property(nonatomic,strong)NSString *buyer_url;

@end
