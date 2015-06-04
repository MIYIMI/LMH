//
//  LMH_BullTableViewCell.h
//  YingMeiHui
//
//  Created by work on 15/5/26.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMH_HtmlParase.h"
#import "HomeVO.h"

@protocol LMH_BullTableViewCellDelegate <NSObject>

- (void)pushUser:(NSString *)user_url;

@optional
- (void)pushProduct:(NSInteger)productID;
- (void)pushWX;

@end

@interface LMH_BullTableViewCell : UITableViewCell

- (void)layOutUI:(BOOL)is_show andVO:(id)cavo;//is_show 是否显示专题介绍作者
@property(nonatomic,assign)id <LMH_BullTableViewCellDelegate> bullDelegate;

@end
