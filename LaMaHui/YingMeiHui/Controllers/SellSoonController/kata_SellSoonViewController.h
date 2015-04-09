//
//  kata_SellSoonViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-3-31.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "KTSellsoonTableViewCell.h"

@interface kata_SellSoonViewController : FTStatefulTableViewController <KTSellsoonTableViewCellDelegate>

- (id)initWithMenuID:(NSInteger)menuid
            andTitle:(NSString *)title
              isRoot:(BOOL)isroot;

@end
