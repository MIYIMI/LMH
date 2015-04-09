//
//  kata_HomeViewController.h
//  YingMeiHui
//
//  Created by work on 14-9-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kata_IndexAdvFocusViewController.h"
#import "FTStatefulTableViewController.h"
#import "KTProductListTableViewCell.h"
#import "kata_LoginViewController.h"

@interface kata_HomeViewController : FTStatefulTableViewController<KATAFocusViewControllerDelegate,KTProductListTableViewCellDelegate,LoginDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong)   KTNavigationController      *   navigationController;
@end
