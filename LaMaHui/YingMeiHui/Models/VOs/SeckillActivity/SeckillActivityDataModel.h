//
//  SeckillActivityDataModel.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeckillActivityProductModel : NSObject
{
    NSNumber *product_id;// 商品iD
    NSString *product_name;// 商品名字.
    NSString *product_image;// 商品图片.
    NSString *product_price;// 商品价格
    NSNumber *begin_at;//商品活动开始时间。
    NSNumber *end_at;// 商品活动结束时间。
    NSNumber *status;//商品状态.  1已开始 | 2已结束 | 3未开始 | 4已售完
    NSNumber *seckill_id;// 秒杀ID.
    
}
@property(nonatomic,strong) NSNumber *product_id;// 商品iD
@property(nonatomic,strong) NSString *product_name;// 商品名字.
@property(nonatomic,strong) NSString *product_image;// 商品图片.
@property(nonatomic,strong) NSString *product_price;// 商品价格
@property(nonatomic,strong) NSNumber *begin_at;//商品活动开始时间。
@property(nonatomic,strong) NSNumber *end_at;// 商品活动结束时间。
@property(nonatomic,strong) NSNumber *status;//商品状态.  1已开始 | 2已结束 | 3未开始 | 4已售完
@property(nonatomic,strong) NSNumber *seckill_id;// 秒杀ID.
@property(nonatomic,strong) NSNumber *serverTimer;// 服务器时间.
-(id)initWtihDict:(NSDictionary *)dict;
@end

@interface SeckillActivityDataModel : NSObject
{
    NSString *serverTimerStr;
    NSArray *timerList;// object is nsnumber
    NSDictionary *productList;// key: timerList  value:NSArray . the array item is
}
@property (nonatomic,strong)    NSString *serverTimerStr;
@property (nonatomic,strong)    NSArray *timerList;// object is nsnumber
@property (nonatomic,strong)    NSDictionary *productList;// key: timerList  value:NSArray . the array item is
-(id)initWithDict:(NSDictionary *)dict;
-(NSTimeInterval )getCurrenTimer;
-(void)stopTimer;
@end
