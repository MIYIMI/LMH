//
//  LMH_EventTableViewCell.h
//  YingMeiHui
//
//  Created by work on 15/5/27.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMH_EventVO.h"

@protocol LMH_EventTableViewCellDelegate <NSObject>

- (void)downShow;

@end

@interface LMH_EventTableViewCell : UITableViewCell

- (void)layOutUI:(LMH_EventVO *)eventVO show:(BOOL)is_show;
@property(nonatomic,assign)id <LMH_EventTableViewCellDelegate> eventDelegate;

@end
