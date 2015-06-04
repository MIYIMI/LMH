//
//  LMH_ReviewTableViewCell.h
//  YingMeiHui
//
//  Created by work on 15/5/28.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMH_EventVO.h"

@protocol LMH_ReviewTableViewCellDelegate <NSObject>

- (void)sendSms:(LMH_EvaluatedVO *)evaVO;

@end

@interface LMH_ReviewTableViewCell : UITableViewCell

- (void)layoutUI:(LMH_EvaluatedVO *)evaluate;
@property(nonatomic,assign)id <LMH_ReviewTableViewCellDelegate> reviewDelegate;

@end
