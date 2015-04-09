//
//  kata_AddressListViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "KTAddressListTableViewCell.h"
#import "kata_LoginViewController.h"

@interface kata_AddressListViewController : FTStatefulTableViewController <KTAddressListTableViewCellDelegate, UIAlertViewDelegate, LoginDelegate>

- (id)initWithSelectID:(NSInteger)selectid isManage:(BOOL)isManage;

@end
