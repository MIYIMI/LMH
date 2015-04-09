//
//  SeckillActivityDataModel.m
//  YingMeiHui
//
//  Created by KevinKong on 14-8-30.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "SeckillActivityDataModel.h"


@interface SeckillActivityProductModel()

@end

@implementation SeckillActivityProductModel
@synthesize product_id;// 商品iD
@synthesize product_name;// 商品名字.
@synthesize product_image;// 商品图片.
@synthesize product_price;// 商品价格
@synthesize begin_at;//商品活动开始时间。
@synthesize end_at;// 商品活动结束时间。
@synthesize status;//商品状态.  1已开始 | 2已结束 | 3未开始 | 4已售完
@synthesize seckill_id;
@synthesize serverTimer;
-(id)initWtihDict:(NSDictionary *)dict{
    if (self = [super init]) {
        NSDictionary *tempDict = dict;
        if ([dict isKindOfClass:[NSString class]]) {
            NSData *respData = [(NSString *)dict dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            tempDict= [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
            
        }

        self.product_id = [tempDict objectForKey:@"product_id"];// 商品iD
        self.product_name  =[tempDict objectForKey:@"product_name"];// 商品名字.
        self.product_image = [tempDict objectForKey:@"product_image"];;// 商品图片.
        self.product_price = [tempDict objectForKey:@"product_price"];// 商品价格
        self.begin_at = [tempDict objectForKey:@"begin_at"];;//商品活动开始时间。
        self.end_at = [tempDict objectForKey:@"end_at"];// 商品活动结束时间。
        self.status = [tempDict objectForKey:@"status"];//商品状态.  1已开始 | 2已结束 | 3未开始 | 4已售完
        self.seckill_id = [tempDict objectForKey:@"seckill_id"];
    }
    return self;
}

@end



@interface SeckillActivityDataModel ()
{
    double changedServerTimer;
    NSTimer *countTimer;
}
@end
@implementation SeckillActivityDataModel
@synthesize  serverTimerStr;
@synthesize  timerList;
@synthesize  productList;

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {

        NSDictionary *dataDict = [dict objectForKey:@"data"];
        self.timerList = [dataDict objectForKey:@"time_list"];
        self.serverTimerStr = [dict objectForKey:@"server_time"];
        NSDictionary *productDict = [dataDict objectForKey:@"product_list"];
        if (!productDict || ![productDict isKindOfClass:[NSDictionary class]]) return self;
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        for (NSString *key in [productDict allKeys]) {
            NSArray *productArray = [productDict objectForKey:key];
            NSMutableArray *newArray = [NSMutableArray array];
            for (NSDictionary *productDetail in productArray) {
                SeckillActivityProductModel *productModel = [[SeckillActivityProductModel alloc] initWtihDict:productDetail];
                if (productModel) {
                    [newArray addObject:productModel];
                }
            }
            [newDict setObject:newArray forKey:key];
        }

        self.productList = newDict;
    }
    return self;
}

-(void)setServerTimerStr:(NSString *)__serverTimerStr{
    serverTimerStr = __serverTimerStr;
    if (serverTimerStr) {
        changedServerTimer = [__serverTimerStr doubleValue];
        [self beginCountdown];
    }
}

#pragma mark timer logic
-(void)beginCountdown{// 开始倒计时
    if (self.serverTimerStr) {
        if (!countTimer && self.timerList.count>0) {
            countTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
//            [countTimer fire];
        }
        


    }
    
}

-(NSTimeInterval )getCurrenTimer{
    return changedServerTimer;
}
-(void)stopTimer{
    if (countTimer) {
        [countTimer invalidate];
        countTimer=nil;
    }
}
-(void)runTimer{
    LMHLog(@" changetimer %lf",changedServerTimer);
    changedServerTimer++;
    for (NSString *timerKey in [self.productList allKeys]) {
        NSArray *productArry = [self.productList objectForKey:timerKey];
        for (SeckillActivityProductModel *productModel in productArry) {
            double beginTimer = [[productModel begin_at] doubleValue];
            double endTimer = [[productModel end_at] doubleValue];
            NSInteger currentSate = [[productModel status] intValue];
            
            // 1已开始 | 2已结束 | 3未开始 | 4已售完
            
            if (currentSate==1 && changedServerTimer>=endTimer) { // 已开始->已结束.
                 [productModel setStatus:[NSNumber numberWithInteger:2]];
            }
            
            if (currentSate==3) {
                if (changedServerTimer>=beginTimer) {// 未开始->已开始.
                    [productModel setStatus:[NSNumber numberWithInteger:1]];
                }
                
            }
        }
    }

    // 怎么刷新UI 呢？通过
}


@end
