//
//  LMHPersonInfoViewController.h
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "FTBaseViewController.h"
#include "kata_LoginViewController.h"
#import "ChangeNickNameController.h"

@interface LMHPersonInfoViewController : FTBaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,LoginDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)NSString *iconViewURL;
@property(nonatomic,strong)NSString *userNameStr;
@property(nonatomic,strong)NSString *VIPRankStr;
@property(nonatomic,strong)NSString *VIPNameStr;


@end
