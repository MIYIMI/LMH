//
//  Home_styleGoodsCell.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-1-5.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeVO.h"


@protocol Home_styleGoodsCellDelegate <NSObject>

- (void)ViewTapClick:(AdvVO *)vo;

@end

@interface Home_styleGoodsCell : UITableViewCell

@property(nonatomic,strong)id<Home_styleGoodsCellDelegate>delegate;

-(void)layoutUI:(HomeBrandVO*)seckillVO;

@end
