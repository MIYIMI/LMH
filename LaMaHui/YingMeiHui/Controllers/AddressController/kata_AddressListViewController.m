//
//  kata_AddressListViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-11.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_AddressListViewController.h"
#import "kata_UserManager.h"
#import "KTAddressListGetRequest.h"
#import "KTAddressDeleteRequest.h"
#import "KTAddressSetDefaultRequest.h"
#import "AddressListVO.h"
#import "kata_AddressEditViewController.h"

#define TABLEBGCOLOR        [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]

@interface kata_AddressListViewController ()
{
    NSInteger _selectID;
    NSInteger _removeAddressID;
    UIButton *_addBtn;
    BOOL _isManage;
    BOOL _isAddressErr;
    BOOL _isEmpty;
}

@end

@implementation kata_AddressListViewController

- (id)initWithSelectID:(NSInteger)selectid isManage:(BOOL)isManage
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _selectID = selectid;
        _removeAddressID = -1;
        _isManage = isManage;
        _isAddressErr = NO;
        _isEmpty = NO;
        self.ifAddPullToRefreshControl = NO;
        self.ifShowTableSeparator = NO;
        
        if (_isManage) {
            self.title = @"地址管理";
        } else {
            self.title = @"选择收货地址";
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_addBtn setEnabled:NO];
    [self loadNewer];
}

#if LMH_Main_Page_Update_logic
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        self.hidesBottomBarWhenPushed = YES;
}
#endif

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
    [self.tableView setBackgroundColor:TABLEBGCOLOR];
    [self.contentView setBackgroundColor:TABLEBGCOLOR];
    [self.tableView setSectionFooterHeight:0];
    [self.tableView setSectionHeaderHeight:0];
    
    if (!_addBtn) {
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(0, 0, 50, 28)];
        [addBtn setTitle:@"新增" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [addBtn addTarget:self action:@selector(addBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        [self.navigationController addRightBarButtonItem:addItem animation:NO];
        _addBtn = addBtn;
    }
}

- (void)addBtnPressed
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    if (self.listData!=nil) {
        NSInteger maxAddressCount = 8;
        if (self.listData.count>=maxAddressCount) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"最多只能添加%zi个地址",maxAddressCount]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    kata_AddressEditViewController *addAddressVC = [[kata_AddressEditViewController alloc] initWithAddessInfo:nil type:@"add"];
    addAddressVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:addAddressVC animated:YES];

}

- (void)enableAddButton
{
    [_addBtn setEnabled:YES];
}


- (void)checkLogin
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.1];
    }
}

- (void)showLoginView
{
    [kata_LoginViewController showInViewController:self];
}

- (UIView *)emptyView
{
    UIView * v = [super emptyView];
    if (v) {
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 105)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productlistempty"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, -40, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, w, 34)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"亲，您还未添加地址，\r\n快去添加吧！"];
        [view addSubview:lbl];
        
        view.center = v.center;
        [v addSubview:view];
    }
    return v;
}

#pragma mark - DeleteAddressRequest
- (void)deleteAddressOperation
{
    [_addBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    if (_removeAddressID != -1) {
        NSString *userid = nil;
        NSString *usertoken = nil;
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
            userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
            usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
        }
        
        if (userid && usertoken) {
            req = [[KTAddressDeleteRequest alloc] initWithUserID:[userid integerValue]
                                                    andUserToken:usertoken
                                                    andAddressID:_removeAddressID];
        }
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(deleteAddressParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)deleteAddressParseResponse:(NSString *)resp
{
    [self performSelectorOnMainThread:@selector(enableAddButton) withObject:nil waitUntilDone:YES];
    
    NSString *hudPrefixStr = @"地址删除";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                    }
                    [self performSelectorOnMainThread:@selector(deleteAddressSection) withObject:nil waitUntilDone:YES];
                    
                } else {
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                    
                    if ([[dataObj objectForKey:@"code"] integerValue] == -102) {
                        _isAddressErr = NO;
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

- (void)deleteAddressSection
{
    [_addBtn setEnabled:YES];
    for (NSInteger i = 0 ; i < self.listData.count; i++) {
        if ([self.listData objectAtIndex:i] && [[self.listData objectAtIndex:i] isKindOfClass:[AddressVO class]]) {
            AddressVO *vo = (AddressVO *)[self.listData objectAtIndex:i];
            if (_removeAddressID == [vo.AddressID integerValue]) {
                [self.listData removeObjectAtIndex:i];
                if (_removeAddressID == _selectID) {
                    if (!_isManage) {
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"address", [NSNumber numberWithInteger:-1], @"addressno", nil];
                        _selectID = -1;
                        if (self.listData.count > 0) {
                            dict = [NSDictionary dictionaryWithObjectsAndKeys:self.listData[0], @"address", [NSNumber numberWithInteger:0], @"addressno", nil];
                            AddressVO *vo = (AddressVO *)[self.listData objectAtIndex:0];
                            _selectID = [vo.AddressID integerValue];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"payAddrSelect" object:nil userInfo:dict];
                    }
                }
                [self.tableView reloadData];
            }
        }
    }
    
    if (self.listData.count <= 0) {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
        if (!_isManage) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"address", [NSNumber numberWithInteger:-1], @"addressno", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payAddrSelect" object:nil userInfo:dict];
            _selectID = -1;
            _isEmpty = YES;
        }
    }
    [stateHud hide:YES afterDelay:1.0];
}

#pragma mark - DefaultSetAddressRequest
- (void)defaultSetAddressOperation:(NSInteger)defaultID
{
    [_addBtn setEnabled:NO];
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
    KTBaseRequest *req = [[KTBaseRequest alloc] init];
    
    if (defaultID != -1) {
        NSString *userid = nil;
        NSString *usertoken = nil;
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
            userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
            usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
        }
        
        if (userid && usertoken) {
            req = [[KTAddressSetDefaultRequest alloc] initWithUserID:[userid integerValue]
                                                        andUserToken:usertoken
                                                        andAddressID:defaultID];
        }
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(defaultSetAddressParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)defaultSetAddressParseResponse:(NSString *)resp
{
    [self performSelectorOnMainThread:@selector(enableAddButton) withObject:nil waitUntilDone:YES];
    
    NSString *hudPrefixStr = @"默认地址设置";
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if (nil != [respDict objectForKey:@"data"] && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]] && [[respDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dataObj = (NSDictionary *)[respDict objectForKey:@"data"];
                if ([[dataObj objectForKey:@"code"] integerValue] == 0) {
                    
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"成功"] waitUntilDone:YES];
                    }
                    [self performSelectorOnMainThread:@selector(defaultSetSuccess) withObject:nil waitUntilDone:YES];
                    
                } else {
                    id messageObj = [dataObj objectForKey:@"msg"];
                    if (messageObj) {
                        if ([messageObj isKindOfClass:[NSString class]] && ![messageObj isEqualToString:@""]) {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:messageObj waitUntilDone:YES];
                        } else {
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:[hudPrefixStr stringByAppendingString:@"失败"] waitUntilDone:YES];
                    }
                    
                    if ([[dataObj objectForKey:@"code"] integerValue] == -102) {
                        _isAddressErr = NO;
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

- (void)defaultSetSuccess
{
    [_addBtn setEnabled:YES];
    [stateHud hide:YES afterDelay:1.0];
    
    [self loadNoState];
}


#pragma mark - stateful tableview datasource && stateful tableview delegate
//stateful表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////
- (KTBaseRequest *)request
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
        req = [[KTAddressListGetRequest alloc] initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken];
    }
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    AddressListVO *listVO = [AddressListVO AddressListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.AddressList;
                        if (objArr.count > 0) {
                            if (!_isManage && _isEmpty) {
                                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:objArr[0], @"address", [NSNumber numberWithInteger:0], @"addressno", nil];
                                AddressVO *vo = objArr[0];
                                _selectID = [vo.AddressID integerValue];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"payAddrSelect" object:nil userInfo:dict];
                            }
                            _isEmpty = NO;
                        }else{
                            _isEmpty = YES;
                        }
                    } else {
                        //listVO.Msg
                        self.statefulState = FTStatefulTableViewControllerError;
                        if ([listVO.Code intValue] == -102) {
                            _isAddressErr = YES;
                            [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:listVO.Msg waitUntilDone:YES];
                            [[kata_UserManager sharedUserManager] logout];
                            [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
                        }
                    }
                } else {
                    self.statefulState = FTStatefulTableViewControllerError;
                }
            } else {
                self.statefulState = FTStatefulTableViewControllerError;
            }
        } else {
            self.statefulState = FTStatefulTableViewControllerError;
        }
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    [self performSelectorOnMainThread:@selector(enableAddButton) withObject:nil waitUntilDone:YES];
    return objArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const ADDRESS = @"address";
    NSInteger row = indexPath.row;
    
    id data = [self.listData objectAtIndex:row];
    if (data && [data isKindOfClass:[AddressVO class]]) {
        AddressVO *vo = (AddressVO *)data;
        
        KTAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADDRESS];
        if (!cell) {
            cell = [[KTAddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADDRESS];
        }
        cell.addressCellDelegate = self;
        if (!_isManage) {
            [cell setAddressData:vo andID:_selectID];
        }else{
            [cell setAddressData:vo andID:-1];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    if (!h) {
        id data = [self.listData objectAtIndex:row];
        if (data && [data isKindOfClass:[AddressVO class]]) {
            AddressVO *vo = (AddressVO *)data;
            
            NSString *addressStr = @"";
            if (vo.Name) {
                addressStr = [addressStr stringByAppendingFormat:@"%@\t", vo.Name];
            }
            
            if (vo.Mobile) {
                addressStr = [addressStr stringByAppendingFormat:@"%@", vo.Mobile];
            }
            addressStr = [addressStr stringByAppendingString:@"\r\n"];
            
            if (vo.Province) {
                addressStr = [addressStr stringByAppendingFormat:@"%@  ", vo.Province];
            }
            
            if (vo.City) {
                addressStr = [addressStr stringByAppendingFormat:@"%@  ", vo.City];
            }
            
            if (vo.Region) {
                addressStr = [addressStr stringByAppendingFormat:@"%@", vo.Region];
            }
            addressStr = [addressStr stringByAppendingString:@"\r\n"];
            
            if (vo.Detail) {
                addressStr = [addressStr stringByAppendingFormat:@"%@", vo.Detail];
            }
            addressStr = [addressStr stringByAppendingString:@"\r\n"];
            
            CGSize addressSize = [addressStr sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(250, 100000) lineBreakMode:NSLineBreakByCharWrapping];
            return addressSize.height + 70;
        }
    }
    return h;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (!_isManage) {
        [self.navigationController popViewControllerAnimated:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[self.listData objectAtIndex:row], @"address", [NSNumber numberWithInteger:row], @"addressno", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payAddrSelect" object:nil userInfo:dict];
    }
}

#pragma mark - KTAddressListTableViewCell Delegate
- (void)addressEditAddress:(AddressVO *)addressVO
{
    if (![[kata_UserManager sharedUserManager] isLogin]) {
        [kata_LoginViewController showInViewController:self];
        return;
    }
    
    if (addressVO) {
        kata_AddressEditViewController *addAddressVC = [[kata_AddressEditViewController alloc] initWithAddessInfo:addressVO type:@"edit"];
        addAddressVC.navigationController = self.navigationController;
        [self.navigationController pushViewController:addAddressVC animated:YES];

    }
}

- (void)addressDeleteAddress:(AddressVO *)addressVO
{
    _removeAddressID = [addressVO.AddressID integerValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否确认删除该地址？"
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = 1000001;
    [alert show];
}

- (void)setDefaultAddress:(AddressVO *)addressVO
{
    NSInteger defaultid = [addressVO.AddressID integerValue];
    
    [self defaultSetAddressOperation:defaultid];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    
    switch (tag) {
        case 1000001:
        {
            if (buttonIndex == 0) {
                [self deleteAddressOperation];
            } else {
                _removeAddressID = -1;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
