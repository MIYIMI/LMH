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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
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
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo_banner"]];
    [logoImage setFrame:CGRectMake(40,30,ScreenW-80,(ScreenW-80)*62/403)];
    
    UIView *introBg = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImage.frame) + 20, ScreenW-40, 160)];
    [introBg setBackgroundColor:[UIColor whiteColor]];
    [introBg.layer setBorderColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1].CGColor];
    [introBg.layer setBorderWidth:0.5];
    
    UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(introBg.frame) - 20, CGRectGetHeight(introBg.frame))];
    [introLbl setFont:[UIFont systemFontOfSize:15.0]];
    [introLbl setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
    [introLbl setText:@"\t辣妈汇致力成为“最专业的辣妈意见领袖”，为妈妈打造一个提供最优质产品及购物建议的时尚特卖平台，为千万妈妈找回美丽、优雅、自信的自己。\n\n\t辣妈汇，“因为懂你，所以专业”。辣妈汇，更懂辣妈的特卖网站。"];
    [introLbl setBackgroundColor:[UIColor clearColor]];
    [introLbl setTextAlignment:NSTextAlignmentCenter];
    [introLbl setNumberOfLines:0];
    [introBg addSubview:introLbl];
    
    UILabel *copyrightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 80, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
    copyrightLbl.font = [UIFont systemFontOfSize:15];
    copyrightLbl.backgroundColor = [UIColor clearColor];
    copyrightLbl.textColor = LMH_COLOR_GRAY;
    copyrightLbl.textAlignment = NSTextAlignmentCenter;
    copyrightLbl.lineBreakMode = NSLineBreakByCharWrapping;
    copyrightLbl.numberOfLines = 2;
    copyrightLbl.text = @"Copyright©2013-2015\n杭州辣妈汇电子商务有限公司";
    
    [self.contentView addSubview:logoImage];
    [self.contentView addSubview:introBg];
    [self.contentView addSubview:copyrightLbl];
}

@end
