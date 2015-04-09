//
//  KTMMBaseTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-28.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMMBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIColor * accessoryCheckmarkColor;
@property (nonatomic, strong) UIColor * disclosureIndicatorColor;

-(void)updateContentForNewContentSize;

@end
