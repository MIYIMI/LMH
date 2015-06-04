//
//  kata_FavListViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-6-25.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_FavListViewController.h"
#import "KTFavListDataGetRequest.h"
#import "KTFavOperateRequest.h"
#import "kata_UserManager.h"
#import "FavListVO.h"
#import "kata_ProductDetailViewController.h"
#import "KTFavListTableViewCell.h"
#import "kata_CartManager.h"

#define FAVLISTPAGESIZE         20
#define EDITNORMALBTNTAG        200003
#define EDITEDITBTNTAG          200004

@interface kata_FavListViewController ()
{
    UIButton *_editBtn;
    UIBarButtonItem *_editItem;
    NSInteger _removeFavGoodID;
    BOOL _editAble;
    NSIndexPath *_removeIndexPath;
    UIButton *toHomeBtn;
}

@end

@implementation kata_FavListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _removeFavGoodID = -1;
        self.ifAddPullToRefreshControl = NO;
        self.title = @"我的收藏";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupEditBtn];
    [self loadNewer];
    [toHomeBtn removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewer) name:@"FavList" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEditBtn
{
    if (!_editBtn) {
        UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        editBtn.tag = EDITNORMALBTNTAG;
        [editBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        
        [editBtn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        _editBtn = editBtn;
        _editItem = editItem;
    }
    [self.navigationController addRightBarButtonItem:_editItem animation:NO];
}

- (void)editBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == EDITNORMALBTNTAG) {
        _editAble = YES;
        [self.tableView setEditing:_editAble animated:YES];
        
        btn.tag = EDITEDITBTNTAG;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        _editAble = NO;
        [self.tableView setEditing:_editAble animated:YES];
        
        btn.tag = EDITNORMALBTNTAG;
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}


-(void)toHomeBtnPressed
{
//    NSArray *viewControllers =[[[self.tabBarController childViewControllers] objectAtIndex:0] childViewControllers];
//    for (UIViewController *vc in viewControllers) {
//        if ([vc isKindOfClass:[KTChannelViewController class]]) {
//            [(KTChannelViewController *)vc selectedTabIndex:0];
//        }
//    }
    self.tabBarController.selectedIndex=0;
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UIView *)emptyView
{
    UIView *view = [super emptyView];
    
    CGFloat w = view.frame.size.width;
    CGFloat h = view.center.y;
    
    [_editBtn setHidden:YES];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favempty"]];
    [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, h - CGRectGetHeight(image.frame) - 20, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
    [view addSubview:image];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, h, w, 15)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
    [lbl setFont:[UIFont systemFontOfSize:14.0]];
    [lbl setText:@"您还未收藏商品"];
    [view addSubview:lbl];
    
    toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setFrame:CGRectMake((w-w/3)/2, h + 60, w/3 , w/3/3)];
    [toHomeBtn.layer setMasksToBounds:YES];
    [toHomeBtn.layer setCornerRadius:9.0];
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 20; // 左端盖宽度
    CGFloat right = 20; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *aImage = [[UIImage imageNamed:@"red_btn_small"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateNormal];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateSelected];
    [toHomeBtn setBackgroundImage:aImage forState:UIControlStateHighlighted];
    [toHomeBtn addTarget:self action:@selector(toHomeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [toHomeBtn.layer setCornerRadius:toHomeBtn.frame.size.height/3];
    [toHomeBtn setTag:1010];
    
    UILabel *toHomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(toHomeBtn.frame), CGRectGetHeight(toHomeBtn.frame))];
    [toHomeLbl setTextColor:[UIColor whiteColor]];
    [toHomeLbl setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [toHomeLbl setTextAlignment:NSTextAlignmentCenter];
    [toHomeLbl setText:@"去首页逛逛"];
    [toHomeLbl setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:15]];
    [toHomeLbl setTag:1011];
    
    [toHomeBtn addSubview:toHomeLbl];
    [self.view addSubview:toHomeBtn];
    view.layer.zPosition=1;
    self.tableView.userInteractionEnabled=YES;
    NSLog(@" view = %zi",view.userInteractionEnabled);
    UITapGestureRecognizer *tapgestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHomeBtnPressed)];
    tapgestrue.numberOfTapsRequired =1;
    [view addGestureRecognizer:tapgestrue];
    NSLog(@"self.bgview.subiews=%@",self.tableView.backgroundView.subviews);
    
    return view;
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
        req = [[KTFavListDataGetRequest alloc] initWithUserID:[userid integerValue]
                                                 andUserToken:usertoken
                                                  andPageSize:FAVLISTPAGESIZE
                                                   andPageNum:self.current];
    }
    
    return req;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSArray *objArr = nil;
    [toHomeBtn removeFromSuperview];
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    FavListVO *listVO = [FavListVO FavListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        objArr = listVO.FavList;
                        
                        [_editBtn setHidden:NO];
                        
                        self.max = ceil([listVO.Total floatValue] / (CGFloat)FAVLISTPAGESIZE);
                    } else {
                        //listVO.Msg
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
    } else {
        self.statefulState = FTStatefulTableViewControllerError;
    }
    
    return objArr;
}

#pragma mark -
#pragma tableView delegate && datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell;
    }
    
    NSInteger row = indexPath.row;
    static NSString *CELL_IDENTIFI = @"FAVLIST_CELL";
    if (!cell) {
        cell = [[KTFavListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    id vo = [self.listData objectAtIndex:row];
    if ([vo isKindOfClass:[FavListCellVO class]]) {
        FavListCellVO *favVO = (FavListCellVO *)vo;
        [(KTFavListTableViewCell *)cell setFavData:favVO];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (!h) {
        return 75;
    }
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == self.listData.count) {
        return;
    }
    if ([[self.listData objectAtIndex:row] isKindOfClass:[FavListCellVO class]]) {
        FavListCellVO *vo = (FavListCellVO *)[self.listData objectAtIndex:row];
        kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.ProductID integerValue] andType:nil andSeckillID:-1];
        detailVC.navigationController = self.navigationController;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    self.selectedIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.listData.count){
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.listData objectAtIndex:indexPath.row] && [[self.listData objectAtIndex:indexPath.row] isKindOfClass:[FavListCellVO class]]) {
            FavListCellVO *vo = (FavListCellVO *)[self.listData objectAtIndex:indexPath.row];
            _removeFavGoodID = [vo.ProductID integerValue];

            [self deleteFavProductOperation];
        }
    }
}

#pragma mark - KTFavOperateRequest
- (void)deleteFavProductOperation
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.contentView];
        stateHud.delegate = self;
        [self.contentView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelFont = [UIFont systemFontOfSize:14.0f];
    [stateHud show:YES];
    
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
        req = [[KTFavOperateRequest alloc] initWithUserID:[userid integerValue]
                                             andUserToken:usertoken
                                             andProductID:_removeFavGoodID
                                                  andType:@"delete"];
    }
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(favProductParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:@"网络错误" waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)favProductParseResponse:(NSString *)resp
{
    NSString * hudPrefixStr = @"取消收藏";
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
                    [self performSelectorOnMainThread:@selector(deleteFavListRow) withObject:nil waitUntilDone:YES];
                    
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

- (void)deleteFavListRow
{
    for (NSInteger i = 0 ; i < self.listData.count; i++) {
        if ([self.listData objectAtIndex:i] && [[self.listData objectAtIndex:i] isKindOfClass:[FavListCellVO class]]) {
            FavListCellVO *vo = (FavListCellVO *)[self.listData objectAtIndex:i];
            if (_removeFavGoodID == [vo.ProductID integerValue]) {
                [self.listData removeObjectAtIndex:i];
                [self.tableView reloadData];
            }
        }
    }
    
    [stateHud hide:YES afterDelay:1.0];
    [self performSelector:@selector(loadEmpty) withObject:nil afterDelay:0.1];
}

//加载空页面
- (void)loadEmpty
{
    if (self.listData.count == 0)
    {
        self.statefulState = FTStatefulTableViewControllerStateEmpty;
    }
}


@end
