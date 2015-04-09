//
//  KTSellsoonTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-1.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTSellsoonTableViewCellDelegate;

@interface KTSellsoonTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTSellsoonTableViewCellDelegate> sellsoonCellDelegate;
@property (strong, nonatomic) NSMutableArray *SellsoonDataArr;

@end

@protocol KTSellsoonTableViewCellDelegate <NSObject>

- (void)tapAtBrand:(NSInteger)brandid andIsSubscribed:(BOOL)subscribed;

@end
