//
//  kata_ReturnGoodsViewController.h
//  YingMeiHui
//
//  Created by work on 15-2-2.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "OrderDetailVO.h"
#import "ReturnOrderDetailVO.h"

@interface kata_ReturnGoodsViewController : FTStatefulTableViewController

- (id)initWithAddress:(detailAddressVO *)address andPartID:(NSInteger)partid;

@end
