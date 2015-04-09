//
//  KTMsgListTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-21.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBeanVO;

typedef enum {
    KTMsgListCellCustomer               =   0,
	KTMsgListCellCustomerService        =   1,
} KTMsgListCellType;

@interface KTMsgListTableViewCell : UITableViewCell

@property (strong, nonatomic) MessageBeanVO *messageData;
@property (nonatomic) KTMsgListCellType cellType;

@end
