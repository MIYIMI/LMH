//
//  kata_HomeViewController.h
//  YingMeiHui
//
//  Created by work on 14-9-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "LimitedSeckillCell.h"

@interface LimitedSeckillViewController : FTStatefulTableViewController<LoginDelegate,LimitedSeckillCellDelegate>
@end

@interface NSDate (WQCalendarLogic)

@end
