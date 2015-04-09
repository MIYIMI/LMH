//
//  kata_CashFailedViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "KTPaymentTableViewCell.h"
#import "kata_WalletBindViewController.h"
#import "UPPayPlugin.h"

@interface kata_CashFailedViewController : FTStatefulTableViewController
<
UIActionSheetDelegate,
LoginDelegate,
KTPaymentTableViewCellDelegate,
kata_WalletBindViewControllerDelegate,
UPPayPluginDelegate
>

@property(nonatomic,strong)NSString *get_creditStr;


- (id)initWithOrderInfo:(NSDictionary *)orderInfo andPay:(BOOL)paytype andType:(BOOL)type;

@end
