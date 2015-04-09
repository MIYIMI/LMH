//
//  HomeSeckillCell.h
//  YingMeiHui
//
//  Created by work on 14-11-9.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeVO.h"

@protocol HomeSeckillCellDelegate <NSObject>

- (void)tapClick:(AdvVO *)vo;

@end

@interface HomeSeckillCell : UITableViewCell
{
    UIView *cellView;
    NSMutableArray *proImgArray;
    NSMutableArray *otherImgArray;
    NSMutableArray *disLblArray;
    NSMutableArray *sellLblArray;
    NSMutableArray *orgLblArray;
}

@property(nonatomic,strong)id<HomeSeckillCellDelegate>delegate;


-(void)layoutUI:(HomeVO*)seckillVO;

@end
