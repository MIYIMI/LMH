//
//  LMHPersonInfoViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-27.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHPersonInfoViewController.h"
#import "kata_SettingsViewController.h"
#import "EGOCache.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "kata_ProtocolViewController.h"
#import "KTNavigationController.h"
#import "kata_AboutViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "kata_AddressListViewController.h"
#import "LMHChangePassworldViewController.h"
#import "LMHChangeUserIconRequest.h"

@interface LMHPersonInfoViewController ()<LoginDelegate>
{
    UITableView *_tableView;
    UIActivityIndicatorView *_waittingIndicator;
    UIBarButtonItem *_menuItem;
    UIActionSheet *actSheet;
    
    //修改用户头像
    UIImageView *_userIconView;
    
    NSString *filePath; //图片在沙盒目录中的路径
    NSString *_getImageURL; //云服务器返回给我的图片URL
    UIImage *_userIconImage;
    NSData *_userImagData;
    
    UILabel *_usernameLabel; //昵称
    
    NSString *userID;
    NSString *str;
    
    BOOL changeFlag;
}

@property (strong, nonatomic) NSMutableArray *tableData;

@property (weak, nonatomic)  UIProgressView *pv;

@end

@implementation LMHPersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isroot = YES;
        self.title = @"个人信息";
        self.hidesBottomBarWhenPushed = YES;
        changeFlag = YES;
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
                               @{@"icon":@"icon_icon",    @"title":@"头像",@"classname":@"nil"},
                               @{@"icon":@"icon_username",@"title":@"昵称",@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_VIP",     @"title":@"会员等级",@"classname":@"nil"},nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_addressManage",@"title":@"地址管理",@"classname":@"nil"},
                               @{@"icon":@"icon_changePassword",@"title":@"修改密码",@"classname":@"nil"}, nil]];
//        [_tableData addObject:[NSArray arrayWithObjects:
//                               @{@"icon":@"nil",@"title":@"登出账号",@"classname":@"nil"}, nil]];
    } else {
        _tableData = [NSMutableArray arrayWithCapacity:3];
        
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_icon",    @"title":@"头像",@"classname":@"nil"},
                               @{@"icon":@"icon_username",@"title":@"昵称",@"classname":@"nil"}, nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_VIP",     @"title":@"会员等级",@"classname":@"nil"},nil]];
        [_tableData addObject:[NSArray arrayWithObjects:
                               @{@"icon":@"icon_addressManage",@"title":@"地址管理",@"classname":@"nil"},
                               @{@"icon":@"icon_changePassword",@"title":@"修改密码",@"classname":@"nil"}, nil]];
        
    }
    
    return _tableData;
}

- (void)createUI
{
    //    [self setupLeftMenuButton];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    [tableview setBackgroundView:nil];
    [tableview setScrollEnabled:NO];
    [tableview setBackgroundColor:[UIColor colorWithRed:1 green:0.97 blue:0.97 alpha:1]];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setSectionFooterHeight:0];
    [tableview setSectionHeaderHeight:0];
    
    //退出按钮
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.frame = CGRectMake(10, 310, ScreenW - 20, 40);
    [loginOutBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_big"] forState:UIControlStateNormal];
    loginOutBtn.titleLabel.font = FONT(15);
    [loginOutBtn addTarget:self action:@selector(loginOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tableview addSubview:loginOutBtn];
    
    if(IOS_7) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:tableview];
    _tableView = tableview;
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePersonInfoNickName:) name:@"changePersonInfoNickName" object:nil];
    
    
}
//接收到通知后会调用
- (void)changePersonInfoNickName:(NSNotification *)notify
{
    if ([notify.object isKindOfClass:[NSString class]]) {
        
        _usernameLabel.text = notify.object;
        
        self.userNameStr = notify.object;  //////// 要赋值
    }
    
}

- (void)loginOutBtnClick
{
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
    return 48.0f;
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
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //用户头像
            _userIconView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 65, 10, 30, 30)];
            NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *startImageFile = [documentsPath stringByAppendingPathComponent:@"usericonFile"];
            NSString *startImagePath = [startImageFile stringByAppendingPathComponent:[NSString stringWithFormat:@"usericon.png"]];
            _userIconView.image = [UIImage imageWithContentsOfFile:startImagePath]?[UIImage imageWithContentsOfFile:startImagePath]:[UIImage imageNamed:@"defaultIcon"];
            
            //圆角处理
            _userIconView.layer.borderWidth = 1;
            _userIconView.layer.borderColor = [[UIColor whiteColor]CGColor];
            _userIconView.layer.cornerRadius = 30/2;
            _userIconView.layer.masksToBounds = YES;
            _userIconView.contentMode = UIViewContentModeScaleAspectFill;
            
            [cell addSubview:_userIconView];
            
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
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //昵称
            _usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 4, ScreenW - 100 - 20, 40)];
            _usernameLabel.text = self.userNameStr;
            _usernameLabel.font = FONT(16);
            _usernameLabel.backgroundColor = [UIColor clearColor];
            _usernameLabel.textColor = LMH_COLOR_GRAY;
            _usernameLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:_usernameLabel];
            
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
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //会员等级
            UIImageView *VIPView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 110, 16, 25, 16)];
            
            if ([self.VIPRankStr intValue]== 1) {
                VIPView.image = [UIImage imageNamed:@"vip1"];
            }
            if ([self.VIPRankStr intValue] == 2) {
                VIPView.image = [UIImage imageNamed:@"vip2"];
            }
            if ([self.VIPRankStr intValue] == 3) {
                VIPView.image = [UIImage imageNamed:@"vip3"];
            }
            if ([self.VIPRankStr intValue] == 4) {
                VIPView.image = [UIImage imageNamed:@"vip4"];
            }
            if ([self.VIPRankStr intValue] == 5) {
                VIPView.image = [UIImage imageNamed:@"vip5"];
            }
            [cell addSubview:VIPView];
            
            UILabel *VIPLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VIPView.frame), 4, 80, 40)];
            VIPLabel.backgroundColor = [UIColor clearColor];
            VIPLabel.font = FONT(16);
            VIPLabel.text = self.VIPNameStr;
            VIPLabel.textColor = LMH_COLOR_GRAY;
            [cell addSubview:VIPLabel];
            
            
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
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //自定义小箭头
            UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go"]];
            cell.accessoryView = logoutImg;
            
            return cell;
        }
        else if (row == 1){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *titleStr = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.textLabel setText:titleStr];
            
            NSString *iconImg = [[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
            [cell.imageView setImage:[UIImage imageNamed:iconImg]];
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
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
            
            return cell;
        }
        
    }
    
    return nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (row == 0) {
//            NSLog(@"头像");
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
            [myActionSheet showInView:self.view];
        }
        if (row == 1) {
//            NSLog(@"昵称");
            ChangeNickNameController *changeNickName = [[ChangeNickNameController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            changeNickName.navigationController = self.navigationController;
            changeNickName.niciname = self.userNameStr;
            [self.navigationController pushViewController:changeNickName animated:YES];
            
        }
    } else if (section == 1) {
        
        
    } else if (section == 2) {
        
        if (row == 0) {
            
//            NSLog(@"地址管理");
            
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            
            //  地址管理
            kata_AddressListViewController *addressVC = [[kata_AddressListViewController alloc] initWithSelectID:-1 isManage:YES];
            addressVC.navigationController = self.navigationController;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
            
        }
        if (row == 1) {
            
//            NSLog(@"修改密码");
            
            LMHChangePassworldViewController *changePassworld = [[LMHChangePassworldViewController alloc]init];
            changePassworld.navigationController = self.navigationController;
            changePassworld.hideNavigationBarWhenPush = YES;
            [self.navigationController pushViewController:changePassworld animated:YES];
            
        }
    }
}


#pragma mark -- 更改头像
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self locationPhoto];
            break;
        case 1:
            //拍 照
            [self takePhoto];
            break;
            
        default:
            break;
    }
}
//从相册选择
- (void)locationPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
//拍照
- (void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
//        [BDProgressHUD autoShowHUDAddedTo:self.view withText:@"模拟器中无法打开照相机，请在真机中使用"];
        [self textStateHUD:@"模拟器中无法打开照相机，请在真机中使用"];
    }
}

#pragma mark -- 当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    _userIconImage = image;
    
    NSData *imgData = nil;
    //当选择的类型是图片
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"])
    {
        //先把图片转成NSData
        imgData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.1);
        _userImagData = imgData;
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imgData attributes:nil];

        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"usericonFile"];
        // 创建目录
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *startImagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"usericon.png"]];
        [imgData writeToFile:startImagePath atomically:YES];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
    }else{
//        imgData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.1);
    }
    
    [self uploadFile];
}

//- (void)uploadFile{
//    
//    //上传过程 显示加载菊花
//    if (!stateHud) {
//        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
//        stateHud.delegate = self;
//        [self.view addSubview:stateHud];
//    }
//    stateHud.mode = MBProgressHUDModeIndeterminate;
//    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
//    [stateHud show:YES];
//    
//    
//    UpYun *uy = [[UpYun alloc] init];
//    
//    uy.successBlocker = ^(id data)
//    {
//        changeFlag = YES;
//        _getImageURL = [data objectForKey:@"url"];
//        
//        _userIconView.image = _userIconImage;  //界面显示
//        [self changeUserImageInfoOperation];
//    };
//    uy.failBlocker = ^(NSError * error)
//    {
//        changeFlag = NO;
//        NSString *message = [error.userInfo objectForKey:@"message"];
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        
//        [stateHud hide:YES];
//    };
//    uy.progressBlocker = ^(CGFloat percent, long long requestDidSendBytes)
//    {
//        [_pv setProgress:percent];
//    };
//
//    /**
//     *	@brief	根据 UIImage  上传
//     */
//    
////    UIImage *image = [UIImage imageNamed:@"icon_trackOne@2x.png"];
////    [uy uploadFile:image saveKey:[self getSaveKey]];
//    
//    /**
//     *	@brief	根据 文件路径 上传
//     */
//    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    
//    [uy uploadFile:filePath saveKey:[self getSaveKey]];
//    
//    /**
//     *	@brief	根据 NSDate  上传
//     */
//    //    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//    //    [uy uploadFile:fileData saveKey:[self getSaveKey]];
//    
//    
//    
//}

-(NSString * )getSaveKey {
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
       userID = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    return [NSString stringWithFormat:@"/uploads/user/avatar/%@.jpg", userID];
}
#pragma mark -- 网络 修改头像

- (void)changeUserImageInfoOperation
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
        
        req = [[LMHChangeUserIconRequest alloc]initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken
                                                   user_image:_getImageURL
                                                    user_name:nil];

    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(changeUserImageInfoParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        changeFlag = NO;
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)changeUserImageInfoParseResponse:(NSString *)resp
{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            [self textStateHUD:@"头像修改成功"];
            return;
        }
    }
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 120) {
        if (buttonIndex == 0) {
            [[kata_UserManager sharedUserManager] logout];
            [[kata_CartManager sharedCartManager] removeCartID];
            [[kata_CartManager sharedCartManager] removeCartCounter];
            [[kata_CartManager sharedCartManager] removeCartSku];
            [_tableView reloadData];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.1];        }
    }
}

- (void)loginCancel{

}

- (void)didLogin{

}

#pragma mark - 上传图片
- (void)uploadFile{
    
    //上传过程 显示加载菊花
    [self loadHUD];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://121.41.77.48:8001/uploadphoto" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传图片，以文件流的格式
        NSData *imageData = _userImagData;
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
            userID = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
        }
        [formData appendPartWithFileData:imageData name:@"photo" fileName:[NSString stringWithFormat:@"%@.png",userID] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        changeFlag = YES;
        _getImageURL = operation.responseString;
        _userIconView.image = _userIconImage;  //界面显示
        [self changeUserImageInfoOperation];
        [self hideHUD];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        changeFlag = NO;
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self hideHUD];
        [stateHud hide:YES];

    }];
}


@end
