//
//  kata_AdressListTableViewController.h
//  YingMeiHui
//
//  Created by work on 14-7-23.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "FTBaseViewController.h"

@interface kata_AdressListTableViewController : FTBaseViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

- (id)initWithStyle:(UITableViewStyle)style
          andRegion:(NSString*)regionFlag
       andRegionPid:(NSNumber*)regionPid
          andAddres:(NSMutableArray*)adress;
@end
