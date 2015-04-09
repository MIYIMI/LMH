//
//  SeckillActivityHeadV.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeckillActivityDataModel.h"

@class  SeckillActivityHeadV;


@protocol SeckillActivityHeadVDelegate <NSObject>

-(void)SeckillActivityHeadV:(SeckillActivityHeadV *)headv categroyDidSelectedIndex:(NSInteger)index;
-(void)SeckillActivityHeadv:(SeckillActivityHeadV *)headV timerBtnDidSelectedIndex:(NSInteger)index;

@end

@interface SeckillActivityHeadVDataModel : NSObject
// 得到时间段个数.
-(NSInteger)getTimerNumCtn;
// 得到时间 str.
-(NSString *)getTimerStrWithIndex:(NSInteger )index;
// 得到时间的 图片 name;
-(NSString *)getTimerImageNameWithIndex:(NSInteger)index;
-(void)setOrignalData:(NSArray *)timerArray;
@end


@interface SeckillActivityHeadV : UIView
{
    id<SeckillActivityHeadVDelegate> delegate;
}
@property (nonatomic,strong) id<SeckillActivityHeadVDelegate> delegate;
-(void)reloadDataModel:(SeckillActivityHeadVDataModel *)dataModel;
-(void)selectedCategoryWithIndex:(NSInteger)index;
@end
