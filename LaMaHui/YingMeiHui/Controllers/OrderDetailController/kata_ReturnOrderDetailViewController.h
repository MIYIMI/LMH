//
//  kata_ReturnOrderDetailViewController.h
//  YingMeiHui
//
//  Created by work on 15-1-30.
//  Copyright (c) 2015年 xieyanke. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "OrderListVO.h"

@interface kata_ReturnOrderDetailViewController : FTStatefulTableViewController

- (id)initWithGoodVO:(OrderGoodsVO *)goodVO andOrderID:(NSString *)orderID andType:(NSInteger)type;

@end
