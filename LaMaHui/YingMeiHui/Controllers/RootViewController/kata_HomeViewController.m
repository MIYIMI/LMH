//
//  kata_HomeViewController.m
//  YingMeiHui
//
//  Created by work on 14-9-17.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_HomeViewController.h"
#import "KTAdverDataGetRequest.h"
#import "KTHomeListRequst.h"
#import "AdvListVO.h"
#import "ProductListVO.h"
#import "kata_ProductDetailViewController.h"
#import "kata_ProductListViewController.h"
#import "kata_WebViewController.h"
#import "BOKUBannerImageButton.h"
#import "kata_FavListViewController.h"
#import "kata_UserManager.h"
#import "kata_CartManager.h"
#import "kata_CouponViewController.h"
#import "kata_IntegralViewController.h"
#import "LimitedSeckillViewController.h"
#import "DMQRCodeViewController.h"
#import "kata_CategoryViewController.h"

#define PAGERSIZE           20
#define TABLE_COLOR         [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define ADVFOCUSHEIGHT      100
#define MENUHEIGHT      115

@interface kata_HomeViewController ()
{
    kata_IndexAdvFocusViewController *_bannerFV;
    UIView *_bannerView;
    UIView *_menuView;
    UIView *_headerView;
    
    kata_CategoryViewController *bradListVC;
    kata_FavListViewController *favListVC;
    kata_CouponViewController *CouponVC;
    kata_IntegralViewController *integralVC;
    LimitedSeckillViewController *LimitedListVC;
    DMQRCodeViewController *QRCodeViewController;
    
    BOOL _isAdvLoaded;
    NSArray *_advArr;
    NSMutableArray *_productDictArr;
}
@end

@implementation kata_HomeViewController
@synthesize navigationController;

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.ifShowTableSeparator = NO;
        self.ifShowScrollToTopBtn = YES;
        self.ifShowBtnHigher = YES;
        _isAdvLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = TABLE_COLOR;
    CGRect frame = self.view.frame;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_logo"]];
    [self.navigationItem setTitleView:logo];

    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        frame.size.height -= 113;
    }
    else
    {
        frame.origin.y -= 20;
        frame.size.height -= 93;
    }
    
    self.tableView.frame = frame;
    
    [self createUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"PageOne"];
    if (!_isAdvLoaded) {
        [self loadADDataOperation];
    }
    [self loadNewer];
    //购物车数量更新
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:1];
    
    NSNumber *countValue = [[kata_CartManager sharedCartManager] cartCounter];
    if ([countValue intValue]>0) {
        [tabBarItem3 setBadgeValue:[[[kata_CartManager sharedCartManager] cartCounter] stringValue]];
    }
    else
    {
        [tabBarItem3 setBadgeValue:0];
    }
    
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    //未支付订单数量更新
     NSNumber *wntValue = [[kata_UserManager sharedUserManager] userWaitPayCnt];
    if ([wntValue intValue]>0) {
        [tabBarItem4 setBadgeValue:[[[kata_UserManager sharedUserManager] userWaitPayCnt] stringValue]];
    }
    else
    {
        [tabBarItem4 setBadgeValue:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_headerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT + MENUHEIGHT)];
    }
    
    //广告活动页视图
    if (!_bannerView) {
        _bannerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_bannerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT)];
    }
    
    //功能列表视图
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectZero];
        [_menuView setFrame:CGRectMake(0, ADVFOCUSHEIGHT+1, CGRectGetWidth(self.view.frame), MENUHEIGHT)];
        for (int i = 0; i < 4; i ++) {
            [self menuButton:i];
        }
    }
    
    [_headerView addSubview:_bannerView];
    [_headerView addSubview:_menuView];
    
    [self.tableView setTableHeaderView:_headerView];
}

//扫一扫
-(void)scanCode
{
    QRCodeViewController = [[DMQRCodeViewController alloc] init];
    QRCodeViewController.hidesBottomBarWhenPushed = YES;
    QRCodeViewController.navigationController = self.navigationController;
    [self.navigationController pushViewController:QRCodeViewController animated:YES];
    
}

#pragma 创建功能菜单
-(void)menuButton:(int)menuID
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.tag = 1000 + menuID;
    [menuBtn setBackgroundColor:[UIColor whiteColor]];
    [menuBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    float menuWidth = CGRectGetWidth(self.view.frame) / 4;
    [menuBtn setFrame:CGRectMake(menuWidth*menuID , 0, menuWidth, 110)];
    
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    [btnBg setContentMode:UIViewContentModeCenter];
    UIImage *imageNor = [UIImage imageNamed:[NSString stringWithFormat:@"menu%d", menuID + 1]];
    [btnBg setImage:imageNor];
    
    UILabel *menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnBg.frame) + 5, menuWidth, 20)];
    [menuTitle setTextAlignment:NSTextAlignmentCenter];
    [menuTitle setFont:[UIFont systemFontOfSize:13.0]];
    [menuTitle setTextColor:[UIColor grayColor]];
    switch (menuID) {
        case 0:
            menuTitle.text = @"掌上秒杀";
            break;
        case 1:
            menuTitle.text = @"品牌特卖";
            break;
        case 2:
            menuTitle.text = @"积分换购";
            break;
        case 3:
            menuTitle.text = @"优惠券";
            break;
        default:
            break;
    }
    
    [menuBtn addSubview:btnBg];
    [menuBtn addSubview:menuTitle];
    [_menuView addSubview:menuBtn];
}

-(void)menuButtonClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1000:
            //进入掌上秒杀
            LimitedListVC = [[LimitedSeckillViewController alloc] initWithNibName:nil bundle:nil];
            LimitedListVC.navigationController = self.navigationController;
            [LimitedListVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:LimitedListVC animated:YES];
            break;
        case 1001:
            //进入品牌特卖
            bradListVC = [[kata_CategoryViewController alloc] initWithMenuID:1 andParentID:0 andTitle:@"品牌特卖" isViewState:ViewStateBrand isFirst:NO];
            bradListVC.navigationController = self.navigationController;
            [bradListVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:bradListVC animated:YES];
            break;
        case 1002:
            //进入积分换购
            integralVC = [[kata_IntegralViewController alloc] initWithNibName:nil bundle:nil];
            integralVC.navigationController = self.navigationController;
            [integralVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:integralVC animated:YES];
            break;
        case 1003:
            //进入优惠券
            if (![[kata_UserManager sharedUserManager] isLogin]) {
                [kata_LoginViewController showInViewController:self];
                return;
            }
            CouponVC = [[kata_CouponViewController alloc] initWithStyle:UITableViewStylePlain];
            CouponVC.navigationController = self.navigationController;
            [CouponVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:CouponVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark 广告页加载
- (void)layoutAdverView:(BOOL)Flag
{
    //如果广告页为空或获取失败，显示默认图
    if (!Flag) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), ADVFOCUSHEIGHT)];
        [imgView setImage:[UIImage imageNamed:@"banner"]];
            [_bannerView addSubview:imgView];
    }
    else
    {
        if (_bannerFV) {
            [_bannerFV.view removeFromSuperview];
            _bannerFV = nil;
        }
        
        if (!_bannerFV) {
            kata_IndexAdvFocusViewController *fvc = [[kata_IndexAdvFocusViewController alloc] initWithData:_advArr];
            fvc.focusViewControllerDelegate = self;
            _bannerFV = fvc;
            
            if (!_isAdvLoaded) {
                _bannerFV.view.alpha = 0;
            }
        }
        
        [_bannerView addSubview:_bannerFV.view];
        
        if (!_isAdvLoaded) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            _bannerFV.view.alpha = 1;
            [UIView commitAnimations];
            _isAdvLoaded = YES;
        }
    }
}

#pragma mark 获取首页商品数据
- (KTBaseRequest *)request
{
    KTHomeListRequst *req = [[KTHomeListRequst alloc] initWithPageSize:PAGERSIZE andPageNum:self.current];
    return req;
}

#pragma mark 首页商品数据返回解析
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
                    ProductListVO *listVO = [ProductListVO ProductListVOWithDictionary:dataObj];
                    if ([listVO.Code intValue] == 0) {
                        
                        if (listVO.ProductList) {
                            NSMutableArray *cellDataArr = [[NSMutableArray alloc] init];
                            for (int i = 0; i < (int)ceil((float)listVO.ProductList.count / 2.0); i++) {
                                NSMutableArray *cellArr = [[NSMutableArray alloc] init];
                                if ([listVO.ProductList objectAtIndex:i * 2] && [[listVO.ProductList objectAtIndex:i * 2] isKindOfClass:[ProductVO class]]) {
                                    [cellArr addObject:[listVO.ProductList objectAtIndex:i * 2]];
                                }
                                
                                if (listVO.ProductList.count > i * 2 + 1) {
                                    if ([listVO.ProductList objectAtIndex:i * 2 + 1] && [[listVO.ProductList objectAtIndex:i * 2 + 1] isKindOfClass:[ProductVO class]]) {
                                        [cellArr addObject:[listVO.ProductList objectAtIndex:i * 2 + 1]];
                                    }
                                }
                                [cellDataArr addObject:cellArr];
                            }
                            
                            if ([dataObj objectForKey:@"productlist"] && [[dataObj objectForKey:@"productlist"] isKindOfClass:[NSArray class]]) {
                                _productDictArr = [NSMutableArray arrayWithArray:[dataObj objectForKey:@"productlist"]];
                            }
                            objArr = [NSArray arrayWithArray:cellDataArr];
                            
                            if (self.max == -1) {
                                self.max = (int)ceil([listVO.Total floatValue] / (float)PAGERSIZE);
                                if (self.max == 0) {
                                    self.max = 1;
                                }
                            }
                        }
                        
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


#pragma mark - Load AD Data
- (void)loadADDataOperation
{
    KTAdverDataGetRequest *req = [[KTAdverDataGetRequest alloc] initWithType:@"home_"];
    
    KTProxy *proxy = [KTProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(loadADDataParseResponse:) withObject:resp waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(layoutAdverView:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
    }];
    
    [proxy start];
}

- (void)loadADDataParseResponse:(NSString *)resp
{
    BOOL Flag = NO;
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *statusStr = [respDict objectForKey:@"status"];
        
        if ([statusStr isEqualToString:@"OK"]) {
            if ([respDict objectForKey:@"data"] != nil && ![[respDict objectForKey:@"data"] isEqual:[NSNull null]]) {
                id dataObj = [respDict objectForKey:@"data"];
                
                if ([dataObj isKindOfClass:[NSDictionary class]]) {
                    AdvListVO *listVO = [AdvListVO AdvListVOWithDictionary:dataObj];
                    
                    if ([listVO.Code intValue] == 0) {
                        _advArr = listVO.AdvList;
                        
                        if (_advArr && _advArr.count > 0) {
                            Flag = YES;
                        }
                        else
                            Flag = NO;
                    }
                    else
                        Flag = NO;
                }
                else
                    Flag = NO;
            }
            else
                Flag = NO;
        }
        else
            Flag = NO;
    }
    [self performSelectorOnMainThread:@selector(layoutAdverView:) withObject:[NSNumber numberWithBool:Flag] waitUntilDone:YES];
}

#pragma mark -
#pragma tableView delegate && datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell;
    }
    
    int row = (int)indexPath.row;
    static NSString *CELL_IDENTIFI = @"CATEINFO_CELL";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFI];
    if (!cell) {
        cell = [[KTProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    }
    
    if ([self.listData objectAtIndex:row] && [[self.listData objectAtIndex:row] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *cellArr = (NSMutableArray *)[self.listData objectAtIndex:row];
        
        [(KTProductListTableViewCell *)cell setProductDataArr:cellArr];
        [(KTProductListTableViewCell *)cell setProductCellDelegate:self];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell setBackgroundColor:[UIColor clearColor]];
    //[cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (!h) {
        return 250;
    }
    return h;
}

#pragma mark - KTProductListTableViewCell Delegate
- (void)tapAtProduct:(int)productid
      andProductName:(NSString *)name
{
    kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:productid andType:nil andSeckillID:-1];
    [detailVC setHidesBottomBarWhenPushed:YES];
    detailVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - KATAFocusViewController Delegate
- (void)didClickFocusItemButton:(id)sender
{
    if ([sender isKindOfClass:[BOKUBannerImageButton class]]) {
        //Slider PUSH
        BOKUBannerImageButton *btn = (BOKUBannerImageButton *)sender;
        if (btn.slider && [btn.slider isKindOfClass:[AdvVO class]]) {
            AdvVO *vo = (AdvVO *)btn.slider;
            if (vo.Type) {
                int type = [vo.Type intValue];
                switch (type) {
                    case 1:
                    {
                        //商品详情页
                        if (vo.Key && [vo.Key intValue] != -1) {
                            kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[vo.Key intValue] andType:nil andSeckillID:-1];
                            [detailVC setHidesBottomBarWhenPushed:YES];
                            detailVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:detailVC animated:YES];
                        }
                    }
                        break;
                        
                    case 2:
                    {
                        //商品列表页
                        if (vo.Key && [vo.Key intValue] != -1) {
                            kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[vo.Key intValue] andTitle:(vo.Title && ![vo.Title isEqualToString:@""])?vo.Title:@"商品列表" isRoot:NO isChannel:NO];
                            [productlistVC setHidesBottomBarWhenPushed:YES];
                            productlistVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:productlistVC animated:YES];
                        }
                    }
                        break;
                        
                    case 3:
                    {
                        //web页
                        if (vo.Key && ![vo.Key isEqualToString:@""]) {
                            NSString *webtitle = nil;
                            if (vo.Title && ![vo.Title isEqualToString:@""]) {
                                webtitle = vo.Title;
                            } else {
                                webtitle = @"辣妈汇活动页";
                            }
                            kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:vo.Key title:webtitle];
                            [webVC setHidesBottomBarWhenPushed:YES];
                            webVC.navigationController = self.navigationController;
                            [self.navigationController pushViewController:webVC animated:YES];
                        }
                    }
                        break;
                    case 4:// 频道类.
                    {
//                        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(kata_HomeViewController)]) {
//                            //[self.delegate kata_HomeViewController:self didSelectedAdV:vo];
//                        }
                    }
                        break;
                    case 5://活动类
                    {
                        if ([vo.Key isEqualToString:@"oneSecKill"]) {// 秒杀活动
                            [[LMHUIManager sharedUIManager] toSeckillActivityVC];
                        }else if ([vo.Key isEqualToString:@"limit_num"]){
                            //限量抢购
                            if (vo.Key && [vo.Key intValue] != -1) {
                                kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[vo.Key intValue] andTitle:(vo.Title && ![vo.Title isEqualToString:@""])?vo.Title:@"限量抢购" isRoot:NO isChannel:NO];
                                [productlistVC setHidesBottomBarWhenPushed:YES];
                                productlistVC.navigationController = self.navigationController;
                                [self.navigationController pushViewController:productlistVC animated:YES];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

#pragma mark - Login Delegate
- (void)didLogin
{
    
}

- (void)loginCancel
{

}

@end
