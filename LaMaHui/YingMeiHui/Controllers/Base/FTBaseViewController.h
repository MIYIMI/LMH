//
//  FTBaseViewController.h
//  FantooApp
//
//  Created by hark2046 on 13-7-3.
//  Copyright (c) 2013年 Fantoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LMH_Config.h"
#import "KTNavigationController.h"
#import "kata_GlobalConst.h"
#import "Loading.h"

extern CGFloat const kSearchBarHeight;

@interface FTBaseViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *stateHud;
    Loading *loading;
    
    BOOL _isroot;
}

@property (nonatomic, strong) UIView                    *   contentView;
@property (nonatomic, strong) KTNavigationController    *   navigationController;
@property (assign) BOOL hideNavigationBarWhenPush;
@property (assign) BOOL hasTabHeight;

- (void)createUI;
- (void)textStateHUD:(NSString *)text;
- (void)loadHUD;
- (void)hideHUD;

@end
