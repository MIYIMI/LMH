//
//  kata_SettingsViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-6.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_SettingsViewController.h"
#import "EGOCache.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "kata_ProtocolViewController.h"
#import "KTNavigationController.h"
#import "kata_AboutViewController.h"
#import "SDImageCache.h"

@interface kata_SettingsViewController ()
{
    UITableView *_tableView;
    UISwitch *_notiSwitch;
    UIActivityIndicatorView *_waittingIndicator;
    NSString *_updateURLStr;
    UIBarButtonItem *_menuItem;
    UIActionSheet *actSheet;
}

@property (strong, nonatomic) NSMutableArray *tableData;

@end

@implementation kata_SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _updateURLStr = nil;
        _isroot = YES;
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
#if LMH_Main_Page_Update_logic
    self.hidesBottomBarWhenPushed= YES;
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [[kata_UpdateManager sharedUpdateManager] setUpdateDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tableData
{
    if([[kata_UserManager sharedUserManager] isLogin]){
        _tableData = [NSMutableArray arrayWithCapacity:4];
        
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"清除缓存",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"关于我们",@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"接收信息",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"特别声明",@"classname":@"nil"},nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"当前版本",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"赐予好评",@"classname":@"nil"}, nil]];
//        [_tableData addObject:[NSArray arrayWithObjects:
//                               @{@"icon":@"nil",@"title":@"登出账号",@"classname":@"nil"}, nil]];
    } else {
        _tableData = [NSMutableArray arrayWithCapacity:3];
        
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"清除缓存",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"关于我们",@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"接收信息",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"特别声明",@"classname":@"nil"},nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"nil",@"title":@"当前版本",@"classname":@"nil"},
                               @{@"icon":@"nil",@"title":@"赐予好评",@"classname":@"nil"}, nil]];
        
    }
    
    return _tableData;
}

-(void)setupLeftMenuButton
{
    if (!_menuItem) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setFrame:CGRectMake(0, 0, 20, 27)];
        UIImage *image = [UIImage imageNamed:@"menubtn"];
        [menuBtn setImage:image forState:UIControlStateNormal];
        //[menuBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        _menuItem = menuItem;
    }
    [self.navigationController addLeftBarButtonItem:_menuItem animation:NO];
}

- (void)createUI
{
//    [self setupLeftMenuButton];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    [tableview setBackgroundView:nil];
    [tableview setScrollEnabled:NO];
    [tableview setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f]];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setSectionFooterHeight:0];
    [tableview setSectionHeaderHeight:0];
    tableview.backgroundColor = [UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableview.frame), 20)];
//    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, CGRectGetWidth(headerView.frame) - 20, 14)];
//    [headerLbl setBackgroundColor:[UIColor clearColor]];
//    [headerLbl setFont:[UIFont systemFontOfSize:14]];
//    [headerLbl setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
//    [headerLbl setText:@"应用设置"];
//    [headerView addSubview:headerLbl];
//    [tableview setTableHeaderView:headerView];
    
    if(IOS_7) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:tableview];
    _tableView = tableview;
}

- (void)doSetNotification
{
    if ([_notiSwitch isOn]) {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)
                                                                                 categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }else{
            //这里还是原来的代码
            UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
        }        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"getdevicetoken"];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"getdevicetoken"];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableView datasource && delegate
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.tableData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *CellIdentifier = @"CELL_IDENTIFY";
    
    if (section == 0) {
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //系统小箭头
            
            //自定义小箭头
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
            cell.accessoryView = logoutImg;
            
            return cell;
        } else if (row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            //自定义小箭头
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
            cell.accessoryView = logoutImg;
            
            return cell;
        }
    } else if (section == 1) {
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (!_notiSwitch) {
                _notiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
                [_notiSwitch setOnTintColor:[UIColor colorWithRed:0.96 green:0.31 blue:0.4 alpha:1]];
                [_notiSwitch addTarget:self action:@selector(doSetNotification) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = _notiSwitch;
            }
            
            [_notiSwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"getdevicetoken"] boolValue] animated:YES];
            return cell;
        }
        if (row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //自定义小箭头
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
            cell.accessoryView = logoutImg;
            
            return cell;
        }
    } else if (section == 2) {
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *albl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 70, 15, 60, 14)];
            [albl setTextColor:LMH_COLOR_SKIN];
            [albl setFont:[UIFont systemFontOfSize:15.0]];
            albl.textAlignment = NSTextAlignmentCenter;
            [albl setBackgroundColor:[UIColor clearColor]];
            [albl setTextAlignment:NSTextAlignmentCenter];
            [albl setText:[NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
            [cell addSubview:albl];
            cell.userInteractionEnabled = NO;
            //自定义小箭头
//            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
//            cell.accessoryView = logoutImg;
            
            return cell;
        }
        else if (row == 1){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //自定义小箭头
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
            cell.accessoryView = logoutImg;
            
            return cell;
            
        }
        

    } else {
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logout_icon"]];
            cell.accessoryView = logoutImg;
            
            return cell;
        }

    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否清除缓存？" message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = 105;
            [alert show];
        }
        if (row == 1) {
            kata_AboutViewController *aboutLMH = [[kata_AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutLMH animated:YES];
        }
    } else if (section == 1) {
        if (row == 1) {
            
            kata_ProtocolViewController *protocolViewController = [[kata_ProtocolViewController alloc] initWithNibName:nil bundle:nil andTitle:@"特别声明"];
            [self.navigationController pushViewController:protocolViewController animated:YES];
        }
    } else if (section == 2) {
        
        if (row == 0) {
            [[kata_UpdateManager sharedUpdateManager] updateApp];
        }
        if (row == 1) {
            NSString *str = @"";
            if (IOS_7) {
                str = [NSString stringWithFormat:
                       @"itms-apps://itunes.apple.com/app/id%@",@"905882879"];
            }else{
                str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%zi",905882879];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    else if (section == 3)
    {
        if (row == 0) {
            if ([[kata_UserManager sharedUserManager] isLogin]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登出账号"
                                                                message:@"是否确认登出账号？"
                                                               delegate:self
                                                      cancelButtonTitle:@"是"
                                                      otherButtonTitles:@"否", nil];
                alert.tag = 120;
                [alert show];
            }
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 14;
    } else if (section == 1) {
        return 14;
    } else if (section == 2) {
        return 14;
    }else if  (section == 3) {
        return 14;
    }
    return 0;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110) {
        if (buttonIndex == 1 && _updateURLStr) {
            NSURL *url = [[NSURL alloc] initWithString:_updateURLStr];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (alertView.tag == 105) {
        if (buttonIndex == 0) {
            if (!stateHud) {
                stateHud = [[MBProgressHUD alloc] initWithView:self.view];
                stateHud.delegate = self;
            }
            [self.view setUserInteractionEnabled:NO];
            stateHud.mode = MBProgressHUDModeIndeterminate;
            [self.view addSubview:stateHud];
            [stateHud show:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[EGOCache currentCache] clearCache];
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (stateHud) {
                        stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
                        stateHud.mode = MBProgressHUDModeText;
                        stateHud.labelText = @"清除成功";
                        [stateHud hide:YES afterDelay:0.6];
                    }
                    [self.view setUserInteractionEnabled:YES];
                });
            });
        }
    } else if (alertView.tag == 120) {
        if (buttonIndex == 0) {
            [[kata_UserManager sharedUserManager] logout];
            [[kata_CartManager sharedCartManager] removeCartID];
            [[kata_CartManager sharedCartManager] removeCartCounter];
            [[kata_CartManager sharedCartManager] removeCartSku];
            [_tableView reloadData];
#if LMH_Main_Page_Update_logic
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.1];
#endif
        }
    }
}

-(void)showEndView
{
    if (_waittingIndicator) {
        [_waittingIndicator stopAnimating];
        [_waittingIndicator removeFromSuperview];
        _waittingIndicator = nil;
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.accessoryView = nil;
        [cell setNeedsDisplay];
        
        UILabel *albl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 14)];
        [albl setTextColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
        [albl setFont:[UIFont systemFontOfSize:13.0]];
        [albl setBackgroundColor:[UIColor clearColor]];
        [albl setTextAlignment:NSTextAlignmentCenter];
        [albl setText:[NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
        cell.accessoryView = albl;
        
        [stateHud hide:YES afterDelay:1];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110 || alertView.tag == 111) {
        [self showEndView];
    }
}

#pragma mark - kata_UpdateManager Delegate
-(void)updateAppResult:(UpdateState)State
{
    if (State == UpdateStateNO) {
        if (!stateHud) {
            stateHud = [[MBProgressHUD alloc] initWithView:self.view];
            stateHud.delegate = self;
        }
        [self.view addSubview:stateHud];
        [stateHud show:YES];
        stateHud.labelFont = [UIFont systemFontOfSize:13.0f];
        stateHud.mode = MBProgressHUDModeText;
        stateHud.labelText = @"网络错误";
    }
    else if(State == UpdateStateYES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前版本是最新版本，无需更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 110;
        [alert show];
    }
    [self showEndView];
}

@end
