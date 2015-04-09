//
//  BDProgressHUD.m
//  BabyDate4iPhone
//
//  Created by sheldon on 8/6/14.
//  Copyright (c) 2014 BabyDate. All rights reserved.
//

#import "BDProgressHUD.h"
#import "MBProgressHUD.h"
@implementation BDProgressHUD
+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
//    [hud setDetailsLabelText:@"加载中..."];
    [hud setMinShowTime:0.5f];
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    
   return [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)autoShowHUDAddedTo:(UIView *)view withText:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMinShowTime:0.5];
    [hud setDetailsLabelText:title];
    [hud setMode:MBProgressHUDModeText];
    [hud hide:YES afterDelay:1.8f];
}
@end
