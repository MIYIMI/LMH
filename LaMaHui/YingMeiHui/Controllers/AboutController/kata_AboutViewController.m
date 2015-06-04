//
//  kata_AboutViewController.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-6.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface kata_AboutViewController ()
{
    UIBarButtonItem *_menuItem;
}

@end

@implementation kata_AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isroot = YES;
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self.contentView setFrame:self.view.frame];
    [self.contentView setBackgroundColor:LMH_COLOR_BACK];
    
    if(!IOS_7){
        CGRect frame = self.contentView.frame;
        frame.origin.y -= 20;
        [self.contentView setFrame:frame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo_banner_2"]];
    [logoImage setFrame:CGRectMake(60,45,ScreenW-120,(ScreenW-120)*40/205)];
    
    UIView *introBg = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(logoImage.frame) + 30, ScreenW-60, 110)];
    [introBg setBackgroundColor:[UIColor whiteColor]];
    [introBg.layer setBorderColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1].CGColor];
    [introBg.layer setBorderWidth:0.5];
    
    UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(introBg.frame) - 20, CGRectGetHeight(introBg.frame))];
    [introLbl setFont:[UIFont systemFontOfSize:12.3]];
    [introLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
    [introLbl setText:@"     辣妈汇——全国最大的辣妈宝贝时尚特卖平台，隶属杭州辣妈汇电子商务有限公司，坚持提供安全、时尚的辣妈婴童品牌特卖，做辣妈&宝贝美丽时尚的缔造者！"];
    [introLbl setBackgroundColor:[UIColor clearColor]];
    [introLbl setTextAlignment:NSTextAlignmentLeft];
    [introLbl setNumberOfLines:0];
    [introBg addSubview:introLbl];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:introLbl.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, introLbl.text.length)];
    introLbl.attributedText = attributedString;
    
    UILabel *copyrightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 70, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
    copyrightLbl.font = [UIFont systemFontOfSize:12];
    copyrightLbl.backgroundColor = [UIColor clearColor];
    copyrightLbl.textColor = LMH_COLOR_LIGHTGRAY;
    copyrightLbl.textAlignment = NSTextAlignmentCenter;
    copyrightLbl.lineBreakMode = NSLineBreakByCharWrapping;
    copyrightLbl.numberOfLines = 2;
    copyrightLbl.text = @"Copyright©2013-2015\n杭州辣妈汇电子商务有限公司";
    
    [self.contentView addSubview:logoImage];
    [self.contentView addSubview:introBg];
    [self.contentView addSubview:copyrightLbl];
}

@end
