//
//  CategoryDataModel.h
//  YingMeiHui
//
//  Created by KevinKong on 14-9-22.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
/* 分类 服务器返回的 数据*/

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif


@interface CategoryDataModel : NSObject
+ (CategoryDataModel *)CategoryDataModelWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)CategoryDataModelWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,strong) NSNumber *cate_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *pid;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSArray *cate_son;
@property (nonatomic,strong) NSString *flag;

@end
