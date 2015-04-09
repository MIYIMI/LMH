//
//  KTOrderDetailProductTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-19.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kata_OrderDetailViewController;
@class OrderGoodsVO;
@class ReturnOrderDetailVO;

@protocol KTOrderDetailProductTableViewCellDelegate <NSObject>

- (void)returnOrder:(OrderGoodsVO*)orderData;

- (void)writeOrder:(ReturnOrderDetailVO*)returnData;

@end

@interface KTOrderDetailProductTableViewCell : UITableViewCell

- (void)setItemData:(OrderGoodsVO *)ItemData  andReturnData:(ReturnOrderDetailVO*)returnData andType:(NSInteger)type;

@property (strong, nonatomic) id<KTOrderDetailProductTableViewCellDelegate> delegate;

@property(nonatomic,strong)NSIndexPath *indexpath;

@end
