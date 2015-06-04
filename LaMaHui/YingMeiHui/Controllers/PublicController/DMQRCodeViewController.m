//
//  DMQRCodeViewController.m
//  DamaiIphone
//
//  Created by XYK on 14-1-14.
//  Copyright (c) 2014年 damai. All rights reserved.
//

#import "DMQRCodeViewController.h"
#import "ZBarSDK.h"
#import "kata_ProductDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AdvVO.h"
#import "kata_ProductListViewController.h"
#import "kata_WebViewController.h"
#import "kata_ActivityViewController.h"
#import "CategoryDetailVC.h"
#import "LimitedSeckillViewController.h"
#import "kata_SignInViewController.h"
#import "kata_LoginViewController.h"

@interface DMQRCodeViewController () <ZBarReaderDelegate,ZBarReaderViewDelegate,LoginDelegate> {
    NSTimer *_timer;
    UIButton *openButton;
    UIImageView *Qrcodeline;
    
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    UIAlertView *alertView;
    
    NSString *symbolStr;
    AVAuthorizationStatus authStatus;
}

@end

#define VIEW_WIDTH self.view.frame.size.height / 2

#define SCANVIEW_EdgeTop self.view.frame.size.height/4 - 64
#define SCANVIEW_EdgeLeft ((self.view.frame.size.width - VIEW_WIDTH) / 2)

#define TINTCOLOR_ALPHA 0.8  //透明度

@implementation DMQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTimer];
    [_readerView start];
    Qrcodeline.frame = CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop + 16 + VIEW_WIDTH/2,VIEW_WIDTH,3);

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self login];
    if (IOS_7) {
        [self fixCheck];
    }
}

- (void)login
{
    self.title=@"扫描二维码";
    //初始化扫描界面
    [self setScanView];
    
    _readerView= [[ZBarReaderView alloc]init];
    _readerView.frame = self.view.frame;
    _readerView.tracksSymbols=NO;
    _readerView.readerDelegate =self;
    _readerView.showsFPS = NO;
    _readerView.torchMode = 3;
    _readerView.tracksSymbols = NO;
    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode =0;
    [self.view addSubview:_readerView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- ZBarReaderViewDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    
    // 判断是否存在”{“
    if([symbolStr rangeOfString:@"{"].location !=NSNotFound){
        NSRange range = [symbolStr rangeOfString:@"{"];
        NSString *string = [symbolStr substringFromIndex:range.location];
        NSData *respData = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        AdvVO *adv = [AdvVO AdvVOWithDictionary:respDict];
        [self nextView:adv];
    }else{
        alertView=[[UIAlertView alloc]initWithTitle:@"二维码内容"message:symbolStr delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_readerView stop];
    [_readerView start];
}

-(void)fixCheck{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){
        //应该是这个，如果不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在\"设置-隐私-相机\"中允许访问相机"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
            
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
}

//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView* upView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop,SCANVIEW_EdgeLeft,VIEW_WIDTH)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc]initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop,VIEW_WIDTH,VIEW_WIDTH)];
    //scanCropView.image=[UIImage imageNamed:@""];
    
    scanCropView.layer.borderColor=[ALL_COLOR CGColor];
    scanCropView.layer.borderWidth=2.0;
    
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    
    //右侧的view
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(SCANVIEW_EdgeLeft + VIEW_WIDTH,SCANVIEW_EdgeTop,SCANVIEW_EdgeLeft,VIEW_WIDTH)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0,VIEW_WIDTH + SCANVIEW_EdgeTop,self.view.frame.size.width,self.view.frame.size.height - SCANVIEW_EdgeTop - VIEW_WIDTH + 64)];
    //    downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc]init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(SCANVIEW_EdgeLeft,10,VIEW_WIDTH,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    //用于开关灯操作的button
    openButton=[[UIButton alloc]initWithFrame:CGRectMake(SCANVIEW_EdgeLeft + VIEW_WIDTH/3 ,65,VIEW_WIDTH/3, 30.0)];
    [openButton setBackgroundImage:[UIImage imageNamed:@"red_btn_small"] forState:UIControlStateNormal];
    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    openButton.layer.masksToBounds = YES;
    openButton.layer.cornerRadius = 5.0;
    [openButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    openButton.backgroundColor=ALL_COLOR;
    openButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [openButton addTarget:self action:@selector(openLight)forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:openButton];
    
    
    //画中间的基准线
    Qrcodeline = [[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop + 16 + VIEW_WIDTH/2, VIEW_WIDTH, 3)];
    Qrcodeline.image = [UIImage imageNamed:@"icon_saoyisao_line"];
    [_scanView addSubview:Qrcodeline];
}

- (void)openLight
{
    if (_readerView.torchMode ==0) {
        _readerView.torchMode =1;
        [openButton setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
        
    }else
    {
        _readerView.torchMode =0;
        [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
    }
    [self stopTimer];
    
    [_readerView stop];
    
}
//二维码的横线移动
- (void)moveUpAndDownLine
{
    CGFloat Y=Qrcodeline.frame.origin.y;
//    CGRect frame = self.view.frame;
//    frame.size.height += frame.size.height>=ScreenH?0:64;
//    self.view.frame = frame;
    if (Y == SCANVIEW_EdgeTop + 16){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:2];
        Qrcodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop + 16 + VIEW_WIDTH, VIEW_WIDTH, 3);
        [UIView commitAnimations];
    }else if(Y == SCANVIEW_EdgeTop + 16 + VIEW_WIDTH){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:2];
        Qrcodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop + 16, VIEW_WIDTH, 3);
        [UIView commitAnimations];
    }
//    NSLog(@">>>>>%f",Y);
    
}

- (void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] ==YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

-(void)nextView:(AdvVO *)nextVO
{
    NSString *userid ;
    NSString *usertoken ;
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isEqualToString:@""]) {
        userid = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"];
    }
    
    if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isKindOfClass:[NSString class]] && ![[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"] isEqualToString:@""]) {
        usertoken = [[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_token"];
    }
    
    NSString *webStr = [NSString stringWithFormat:@"?user=%@&token=%@", userid,usertoken];
    
    if (nextVO.Type) {
        NSInteger type = [nextVO.Type integerValue];
        switch (type) {
            case 0:
            {
                if (![[kata_UserManager sharedUserManager] isLogin]) {
                    [kata_LoginViewController showInViewController:self];
                }
            }
                break;
            case 1://商品详情页
            {
                if (nextVO.Key && [nextVO.Key intValue] != -1) {
                    kata_ProductDetailViewController *detailVC = [[kata_ProductDetailViewController alloc] initWithProductID:[nextVO.Key intValue] andType:nil andSeckillID:-1];
                    detailVC.hidesBottomBarWhenPushed = YES;
                    detailVC.navigationController = self.navigationController;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
                break;
                
            case 2:
            {
                //商品列表页
                if (nextVO.Key && [nextVO.Key integerValue] != -1) {
                    kata_ProductListViewController *productlistVC = [[kata_ProductListViewController alloc] initWithBrandID:[nextVO.Key intValue] andTitle:nextVO.Title andProductID:0 andPlatform:nextVO.platform isChannel:NO];
                    productlistVC.navigationController = self.navigationController;
                    productlistVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productlistVC animated:YES];
                }
            }
                break;
                
            case 3:
            {
                //web页
                if (nextVO.Key && ![nextVO.Key isEqualToString:@""]) {
                    NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:nextVO.platform];
                    webVC.navigationController = self.navigationController;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
                break;
            case 4:// 活动类页.
            {
                kata_ActivityViewController *actvityVC = [[kata_ActivityViewController alloc] initWithData:nextVO];
                actvityVC.navigationController = self.navigationController;
                actvityVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:actvityVC animated:YES];
            }
                break;
            case 5://弹窗活动类
            {
                if ([nextVO.Key isEqualToString:@"register"]) {// 注册活动
                    kata_RegisterViewController *regisetVC = [[kata_RegisterViewController alloc] initWithNibName:nil bundle:nil];
                    regisetVC.hidesBottomBarWhenPushed = YES;
                    regisetVC.navigationController = self.navigationController;
                    [self.navigationController pushViewController:regisetVC animated:YES];
                }
            }
                break;
            case 6:
            {
                //web页可操作app页面
                if (nextVO.Key && ![nextVO.Key isEqualToString:@""]) {
                    NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                    kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:nextVO.platform];
                    webVC.navigationController = self.navigationController;
                    webVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
                break;
            case 7://专场活动类
            {
                kata_ActivityViewController *actvityVC = [[kata_ActivityViewController alloc] initWithData:nextVO];
                actvityVC.navigationController = self.navigationController;
                actvityVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:actvityVC animated:YES];
            }
                break;
            case 8://分类页
            {
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"category"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationItem.title = nextVO.Title;
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
                break;
            case 9:
            {
                // 品牌团
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"get_brand_tuan_list"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
                break;
            case 10:
            {
                // 9.9包邮
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"get_nine_list"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
                break;
            case 12:
            {
                // 属性分类页
                CategoryDetailVC *productlistVC = [[CategoryDetailVC alloc] initWithAdvData:nextVO andFlag:@"attr"];
                productlistVC.pid = @0;
                productlistVC.cateid = [NSNumber numberWithInteger:[nextVO.Key integerValue]];
                productlistVC.navigationItem.title = nextVO.Title;
                productlistVC.navigationController = self.navigationController;
                productlistVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productlistVC animated:YES];
            }
                break;
            case 99:
            {
                //签到赚金豆
                kata_SignInViewController *signInVC = [[kata_SignInViewController alloc] initWithTitle:@"每日签到"];
                signInVC.navigationController = self.navigationController;
                signInVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:signInVC animated:YES];
            }
                break;
            case 100:
            {
                // 红包裂变
                NSString *webUrl = [nextVO.Key stringByAppendingString:webStr];
                kata_WebViewController *webVC = [[kata_WebViewController alloc] initWithUrl:webUrl title:nil andType:@"lamahui"];
                webVC.navigationController = self.navigationController;
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 101:
            {
                //秒杀
                LimitedSeckillViewController *skillVC = [[LimitedSeckillViewController alloc] initWithStyle:UITableViewStylePlain];
                skillVC.navigationController = self.navigationController;
                skillVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:skillVC animated:YES];
            }
                break;
            default:
                alertView=[[UIAlertView alloc]initWithTitle:@"二维码内容"message:symbolStr delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                [alertView show];
                break;
        }
    }else {
        alertView=[[UIAlertView alloc]initWithTitle:@"二维码内容"message:symbolStr delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)didLogin{
    
}

- (void)loginCancel{
    
}

@end

