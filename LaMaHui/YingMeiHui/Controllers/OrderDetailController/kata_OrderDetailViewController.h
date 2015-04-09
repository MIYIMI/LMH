//
//  kata_OrderDetailViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-18.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "KTOrderDetailProductTableViewCell.h"


@interface kata_OrderDetailViewController : FTStatefulTableViewController <LoginDelegate,UIAlertViewDelegate,UITextViewDelegate>

- (id)initWithOrderID:(NSString *)orderid andType:(NSInteger)orderType antPartnerID:(NSInteger)partid;

@end
