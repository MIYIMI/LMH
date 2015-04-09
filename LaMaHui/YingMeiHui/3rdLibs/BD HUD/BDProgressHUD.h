//
//  BDProgressHUD.h
//  BabyDate4iPhone
//
//  Created by sheldon on 8/6/14.
//  Copyright (c) 2014 BabyDate. All rights reserved.
//

#import <Foundation/Foundation.h>
//@TODO 短暂停留的HUD 2秒
@interface BDProgressHUD : NSObject

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

+ (void)autoShowHUDAddedTo:(UIView *)view withText:(NSString *)title;
@end
