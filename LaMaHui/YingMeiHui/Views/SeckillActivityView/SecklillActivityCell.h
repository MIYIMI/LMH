//
//  SecklillActivityCell.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeckillActivityDataModel.h"


@interface SecklillActivityCellItemModel : NSObject
{
    
}
// 得到Head 时间的名字.
-(NSString *)getHeadTimerImageName;
// 得到Head 时间的 小时
-(NSString *)getHeadTimerStrHH;
// 得到Head 时间的 分钟
-(NSString *)getHeadTimerStrMM;
// 得到 商品 的 URL
-(NSString *)getCommodityImageURL;
// 得到 商品 的 title
-(NSString *)getCommodityTitle;
// 得到 商品 的 原始价格.
-(NSString *)getCommodityOriginalPrice;
// 得到 商品 的 旧价格
-(NSString *)getCommodityNewPrice;
// 得到 商品 的 状态. //  立即抢购,即将开奖，已抢光.
-(NSString *)getCommodityStateStr;
// 得到 商品 状态 字体颜色.
-(UIColor *)getCommodityStateStrColor;
// 得到 商品 状态 背景图片.
-(NSString *)getCommodityStateImage;



+(CGFloat)getCellHeight;

-(void)setSeckllActivityProductModel:(SeckillActivityProductModel *)productModel;


@end



@interface SecklillActivityCellHeadContentV : UIView
-(void)setHeadImageVName:(NSString *)imageVName;
-(void)setHeadHHStr:(NSString *)str;
-(void)setHeadMMStr:(NSString *)str;
@end

@class SecklillActivityCellBodyContentV;
@protocol SecklillActivityCellBodyContentVDeelgate <NSObject>

-(void)SecklillActivityCellBodyContentVSeckillBtnAction:(SecklillActivityCellBodyContentV *)contentV;

@end

@interface SecklillActivityCellBodyContentV : UIView
-(void)setCommodityIMageURLStr:(NSString *)str;
-(void)setCommodityOriginalPrice:(NSString *)str;
-(void)setCommodityImageState:(NSString *)stateStr;
-(void)setCommodityNewPrice:(NSString *)newPrice;
-(void)setCommodityTitle:(NSString *)titleStr;
-(void)setCommodityStateBgImageStr:(NSString *)imageStr;
@property (nonatomic,strong) id<SecklillActivityCellBodyContentVDeelgate> delegate;
@end


@class SecklillActivityCell;
@protocol SecklillActivityCellDeleate <NSObject>

-(void)SecklillActivityCell:(SecklillActivityCell *)cell didSelectedIndex:(NSIndexPath *)indexPath;

@end
@interface SecklillActivityCell : UITableViewCell<SecklillActivityCellBodyContentVDeelgate>
{
    
}
@property (nonatomic,strong) NSIndexPath *inexPath;
@property (nonatomic,strong) id<SecklillActivityCellDeleate> cellDelegate;
-(void)reloadCellWithCellItemModel:(SecklillActivityCellItemModel *)cellModel;
@end




