//
//  kata_WalletViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-20.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_WalletViewController.h"
#import "kata_UserManager.h"
#import "KTWalletInfoGetRequest.h"
#import "WalletInfoVO.h"
#import "kata_WalletDetailViewController.h"
#import "kata_WalletBindViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface kata_WalletViewController ()
{
    UILabel *_totalLbl;
    UILabel *_usableLbl;
    UILabel *_dealingLbl;
    BOOL _isBind;
}

@end

@implementation kata_WalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifAddPullToRefreshControl = NO;
        _isBind = YES;
        self.title = @"我的钱包";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getWalletInfoOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]];
    [self.tableView setSectionHeaderHeight:12.0];
    [self.tableView setSectionFooterHeight:0.0];
    if(IOS_7) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.2];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

- (void)layoutWalletInfoView:(WalletInfoVO *)walletInfo
{
    if (walletInfo) {
        if (walletInfo.Total) {
            NSString *Total;
            CGFloat Money = [walletInfo.Total floatValue];
            if ((Money * 10) - (int)(Money * 10) > 0) {
                Total = [NSString stringWithFormat:@"¥%0.2f",[walletInfo.Total floatValue]];
            } else if(Money - (int)Money > 0) {
                Total = [NSString stringWithFormat:@"¥%0.1f",[walletInfo.Total floatValue]];
            } else {
                Total = [NSString stringWithFormat:@"¥%0.0f",[walletInfo.Total floatValue]];
            }
            [_totalLbl setText:Total];
        } else {
            [_totalLbl setText:@"￥"];
        }
        
        if (walletInfo.Usable) {
            NSString *Usable;
            CGFloat able = [walletInfo.Usable floatValue];
            if ((able * 10) - (int)(able * 10) > 0) {
                Usable = [NSString stringWithFormat:@"¥%0.2f",[walletInfo.Usable floatValue]];
            } else if(able - (int)able > 0) {
                Usable = [NSString stringWithFormat:@"¥%0.1f",[walletInfo.Usable floatValue]];
            } else {
                Usable = [NSString stringWithFormat:@"¥%0.0f",[walletInfo.Usable floatValue]];
            }
            [_usableLbl setText:Usable];
        } else {
            [_usableLbl setText:@"￥"];
        }
        
        if (walletInfo.Dealing) {
            NSString *dealing;
            CGFloat ling = [walletInfo.Dealing floatValue];
            if ((ling * 10) - (int)(ling * 10) > 0) {
                dealing = [NSString stringWithFormat:@"¥%0.2f",[walletInfo.Dealing floatValue]];
            } else if(ling - (int)ling > 0) {
                dealing = [NSString stringWithFormat:@"¥%0.1f",[walletInfo.Dealing floatValue]];
            } else {
                dealing = [NSString stringWithFormat:@"¥%0.0f",[walletInfo.Dealing floatValue]];
            }
            [_dealingLbl setText:dealing];
        } else {
            [_dealingLbl setText:@"￥"];
        }
        
        if (walletInfo.Bind) {
            _isBind = [walletInfo.Bind boolValue];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - GetUserInfoRequest
- (void)getWalletInfoOperation
{
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    NSString *userid = nil;
    NSString *usertoken = nil;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    if (userid && usertoken) {
        req = [[KTWalletInfoGetRequest alloc] initWithUserID:[userid integerValue]
                                                andUserToken:usertoken];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(getWalletInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)getWalletInfoParseResponse:(NSString *)resp
{
    NSString *hudPrefixStr = @"获取钱包信息";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                WalletInfoVO *vo = [WalletInfoVO WalletInfoVOWithDictionary:dataObj];
                
                if ([vo.Code intValue] == 0) {
                    
                    [self layoutWalletInfoView:vo];
                    
                } else {
                    if (vo.Msg) {
                        if ([vo.Msg isKindOfClass:[NSString class]] && ![vo.Msg isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:vo.Msg waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                    if ([vo.Code intValue] == -102) {
                        [[kata_UserManager sharedUserManager] logout];
                        [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                    }
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        } else {
            id messageObj = [respDict objectForKey:@"msg"];
            if (messageObj) {
                if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                }
            } else {
                [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
            }
        }
    } else {
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
    }
}

#pragma mark -
#pragma tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isBind) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const WALLETINFO = @"walletinfo";
    static NSString *const CONSOLE = @"console";
    
    NSInteger row = indexPath.row;
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WALLETINFO];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WALLETINFO];
            
            UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(10, 9, w - 20, 89)];
            [infoView setBackgroundColor:[UIColor whiteColor]];
            [infoView.layer setCornerRadius:2.0];
            [infoView.layer setShadowColor:[UIColor grayColor].CGColor];
            [infoView.layer setShadowOpacity:0.1];
            [infoView.layer setShadowOffset:CGSizeMake(0, 0)];
            [infoView.layer setBorderWidth:0.5];
            [infoView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.83 blue:0.84 alpha:1].CGColor];
            UILabel *vlineLbl = [[UILabel alloc] initWithFrame:CGRectMake(77, 0, 0.5, CGRectGetHeight(infoView.frame))];
            [vlineLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
            UILabel *hlineLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vlineLbl.frame), CGRectGetHeight(infoView.frame) / 2, CGRectGetWidth(infoView.frame) - CGRectGetMaxX(vlineLbl.frame), 0.5)];
            [hlineLbl setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
            
            UILabel *totalTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, CGRectGetMinX(vlineLbl.frame), 15.0)];
            [totalTip setFont:[UIFont systemFontOfSize:13.0]];
            [totalTip setBackgroundColor:[UIColor clearColor]];
            [totalTip setTextAlignment:NSTextAlignmentCenter];
            [totalTip setText:@"钱包总额"];
            
            if (!_totalLbl) {
                _totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalTip.frame) + 6, CGRectGetMinX(vlineLbl.frame), 15.0)];
                [_totalLbl setFont:[UIFont systemFontOfSize:13.0]];
                [_totalLbl setBackgroundColor:[UIColor clearColor]];
                [_totalLbl setTextColor:[UIColor colorWithRed:0.7 green:0.17 blue:0 alpha:1]];
                [_totalLbl setTextAlignment:NSTextAlignmentCenter];
                [infoView addSubview:_totalLbl];
            }
            
            UILabel *usableTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(totalTip.frame) + 10, 0, CGRectGetWidth(infoView.frame) - CGRectGetWidth(totalTip.frame) - 20, CGRectGetHeight(infoView.frame) / 2)];
            [usableTip setFont:[UIFont systemFontOfSize:13.0]];
            [usableTip setBackgroundColor:[UIColor clearColor]];
            [usableTip setTextAlignment:NSTextAlignmentLeft];
            [usableTip setText:@"可用余额:"];
            
            if (!_usableLbl) {
                _usableLbl = [[UILabel alloc] initWithFrame:usableTip.frame];
                [_usableLbl setFont:[UIFont systemFontOfSize:13.0]];
                [_usableLbl setBackgroundColor:[UIColor clearColor]];
                [_usableLbl setTextColor:[UIColor colorWithRed:0.7 green:0.17 blue:0 alpha:1]];
                [_usableLbl setTextAlignment:NSTextAlignmentRight];
                [infoView addSubview:_usableLbl];
            }
            
            UILabel *dealingTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(totalTip.frame) + 10, CGRectGetMaxY(hlineLbl.frame), CGRectGetWidth(infoView.frame) - CGRectGetWidth(totalTip.frame) - 20, CGRectGetHeight(infoView.frame) / 2)];
            [dealingTip setFont:[UIFont systemFontOfSize:13.0]];
            [dealingTip setBackgroundColor:[UIColor clearColor]];
            [dealingTip setTextAlignment:NSTextAlignmentLeft];
            [dealingTip setText:@"提现中金额:"];
            
            if (!_dealingLbl) {
                _dealingLbl = [[UILabel alloc] initWithFrame:dealingTip.frame];
                [_dealingLbl setFont:[UIFont systemFontOfSize:13.0]];
                [_dealingLbl setBackgroundColor:[UIColor clearColor]];
                [_dealingLbl setTextColor:[UIColor colorWithRed:0.7 green:0.17 blue:0 alpha:1]];
                [_dealingLbl setTextAlignment:NSTextAlignmentRight];
                [infoView addSubview:_dealingLbl];
            }
            
            [infoView addSubview:vlineLbl];
            [infoView addSubview:hlineLbl];
            [infoView addSubview:totalTip];
            [infoView addSubview:usableTip];
            [infoView addSubview:dealingTip];
            [cell.contentView addSubview:infoView];
        }
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONSOLE];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONSOLE];
        }
        
        if (row == 1) {
            [cell.textLabel setText:@"查询明细"];
        } else if (row == 2) {
            [cell.textLabel setText:@"添加绑定"];
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [cell setBackgroundView:bg];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0:
        {
            return 107;
        }
            break;
            
        default:
        {
            return 44;
        }
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 1) {
        if (![[kata_UserManager sharedUserManager] isLogin]) {
            [kata_LoginViewController showInViewController:self];
            return;
        }
        
        kata_WalletDetailViewController *detailVC = [[kata_WalletDetailViewController alloc] initWithNibName:nil bundle:nil];
        detailVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (row == 2) {
        if (![[kata_UserManager sharedUserManager] isLogin]) {
            [kata_LoginViewController showInViewController:self];
            return;
        }
        
        kata_WalletBindViewController *bindVC = [[kata_WalletBindViewController alloc] initWithNibName:nil bundle:nil];
        bindVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:bindVC animated:YES];
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    [self getWalletInfoOperation];
}

- (void)loginCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
