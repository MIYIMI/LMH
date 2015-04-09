//
//  LimitedSeckillCell.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-10-27.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LimitedSeckillVO.h"
typedef enum buyButtonType{
    buyButtonTypeGoToBuy,
    buyButtonTypeOutOfStock,
    buyButtonTypeWillStart
} buyButtonType;

@protocol  LimitedSeckillCellDelegate<NSObject>

//- (void)changeMenuBtn:(NSNumber *)direct; //手势

- (void)buyBtnClick:(LimitedSeckillVO *)model; //提醒按钮

@end

@interface LimitedSeckillCell : UITableViewCell
{
    LimitedSeckillVO *_model;
}

@property(nonatomic,strong)UIView      *bgView;
@property(nonatomic,strong)UIImageView *picView;
@property(nonatomic,strong)UILabel     *titleLabel;
@property(nonatomic,strong)UIImageView *limitedNumberView;
@property(nonatomic,strong)UILabel     *limitedNumberLabel;
@property(nonatomic,strong)UIView      *graySeparateLine;
@property(nonatomic,strong)UILabel     *oldPriceLabel;
@property(nonatomic,strong)UILabel     *monryViewLabel;
@property(nonatomic,strong)UILabel     *priceLabel;
@property(nonatomic,strong)UIImageView *VSView;
@property(nonatomic,strong)UILabel     *taobaoWordLabel;
@property(nonatomic,strong)UILabel     *taobaoPriceLabel;
@property(nonatomic,strong)UIButton    *buyStatusBtn;
@property(nonatomic,strong)UIImageView *outview;
@property(nonatomic,strong)UILabel     *lineView;
@property(nonatomic,strong)NSString    *taobaoDetailURL;

@property(nonatomic,assign)buyButtonType type;



@property(nonatomic,strong)id<LimitedSeckillCellDelegate>delegate;

@property(nonatomic,strong) NSIndexPath *indexPath;  //记录行数

- (void)configContent:(LimitedSeckillVO *)model;

//-(void)reloadData:(buyButtonType)type;

@end
