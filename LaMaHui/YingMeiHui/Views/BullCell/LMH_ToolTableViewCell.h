//
//  LMH_ToolTableViewCell.h
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVO.h"

@protocol LMH_ToolTableViewCellDelegate <NSObject>

@optional
- (void)toolClick:(NSInteger)index andVO:(CampaignVO *)camvo;

@end

@interface LMH_ToolTableViewCell : UITableViewCell

- (void)layoutUI:(id)camvo and_home:(BOOL)flag;//是否是首页进入
@property(nonatomic,assign)id <LMH_ToolTableViewCellDelegate> toolDelegate;

@end
