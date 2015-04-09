//
//  KTProductListTableViewCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductVO.h"

@protocol KTProductListTableViewCellDelegate;

@interface KTProductListTableViewCell : UITableViewCell

@property (assign, nonatomic) id<KTProductListTableViewCellDelegate> productCellDelegate;
@property (strong, nonatomic) NSMutableArray *ProductDataArr;

@end

@protocol KTProductListTableViewCellDelegate <NSObject>

- (void)tapAtProduct:(ProductVO *)pdata;

@end
