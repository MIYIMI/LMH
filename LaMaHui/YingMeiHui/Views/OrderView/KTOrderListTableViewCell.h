//
//  KTOrderListTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderBeanVO;

@interface KTOrderListTableViewCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) OrderBeanVO *OrderData;

@end
