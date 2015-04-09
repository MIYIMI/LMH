//
//  LMHHome_eightCircleCell.h
//  YingMeiHui
//
//  Created by Zhumingming on 15-3-11.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeVO.h"
@protocol LMHHome_eightCircleCellDelegate <NSObject>

//写一个方法
- (void)tapClick:(AdvVO *)vo;

@end


@interface LMHHome_eightCircleCell : UITableViewCell

@property(nonatomic,strong)id<LMHHome_eightCircleCellDelegate>delegate;

-(void)layoutUI:(HomeVO*)eightCircleVO;

@end
