//
//  kata_ShopCartViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-8-3.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "KTShopCartTableViewCell.h"
#import "kata_LoginViewController.h"
#import "Loading.h"

@protocol shopCartDelegate <NSObject>

@optional
- (void)cartViewViewPresented;
- (void)cartCancel;

@end

@interface kata_ShopCartViewController : FTStatefulTableViewController
<
KTShopCartTableViewCellDelegate,
UIAlertViewDelegate,
LoginDelegate
>
@property (assign, nonatomic) id<shopCartDelegate> cartDelegate;
#if LMH_Main_Page_Update_logic
@property (nonatomic) BOOL isRoot;// 是否是TabBar上的ViewController.
#endif
+ (void)showInViewController:(id<shopCartDelegate>)mainVC;

@end
