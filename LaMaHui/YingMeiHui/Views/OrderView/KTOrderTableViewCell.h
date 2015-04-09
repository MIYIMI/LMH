//
//  KTOrderTableViewCell.h
//  YingMeiHui
//
//  Created by work on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderEventVO;

@protocol KTOrderTableViewCellDelegate <NSObject>

- (void)orderBtnClick:(NSInteger)btnType andIndex:(NSIndexPath *)indexPath andEventVO:(OrderEventVO*)eventVO;

@end

@interface KTOrderTableViewCell : UITableViewCell

- (void)layoutUI:(id)dataVO andIndex:(NSIndexPath *)indexPath;
@property (nonatomic,retain)id<KTOrderTableViewCellDelegate> delegate;

@end
