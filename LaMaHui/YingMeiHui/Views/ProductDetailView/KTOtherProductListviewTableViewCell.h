//
//  KTOtherProductListviewTableViewCell.h
//  YingMeiHui
//
//  Created by work on 14-10-9.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeProductVO.h"

@protocol KTOtherProductListviewTableViewCellDelegate <NSObject>

- (void)tapAtProduct:(LikeProductVO *)likevo;

@end

@interface KTOtherProductListviewTableViewCell : UITableViewCell


@property (assign, nonatomic) id<KTOtherProductListviewTableViewCellDelegate> productCellDelegate;
@property (strong, nonatomic) NSMutableArray *ProductDataArr;
@end
