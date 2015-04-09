//
//  LMHContectServiceViewController.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-28.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHContectServiceViewController.h"

@interface LMHContectServiceViewController ()
{
    UIWebView *webView;
}
@end

@implementation LMHContectServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"联系客服";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //更换导航条
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_lightGray"] forBarMetrics:UIBarMetricsDefault];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    self.hidesBottomBarWhenPushed = YES;

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW , ScreenH - 64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chat10.live800.com/live800/chatClient/chatbox.jsp?companyID=425740&configID=217296&jid=8065123196&enterurl=APP%E5%92%A8%E8%AF%A2"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
