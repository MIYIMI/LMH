//
//  KTBrandProductListCell.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItemVO;

@protocol KTBrandProductListCellDelegate;

@interface KTBrandProductListCell : UITableViewCell

@property (assign, nonatomic) id<KTBrandProductListCellDelegate> braproCellDelegate;
@property (strong, nonatomic) NSMutableArray *ItemDataArr;

@end

@protocol KTBrandProductListCellDelegate <NSObject>

- (void)tapAtItem:(MenuItemVO *)vo;

@end
