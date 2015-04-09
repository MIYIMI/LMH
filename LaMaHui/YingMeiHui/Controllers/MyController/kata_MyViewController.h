//
//  kata_MyViewController.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-8.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "FTStatefulTableViewController.h"
#import "kata_LoginViewController.h"
#import "kata_RegisterViewController.h"

@interface kata_MyViewController : FTStatefulTableViewController <LoginDelegate, kata_RegisterViewControllerDelegate>

- (id)initWithIsRoot:(BOOL)isroot;

@end
