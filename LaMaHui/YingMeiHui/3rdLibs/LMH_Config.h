//
//  LMH_Config.h
//  YingMeiHui
//
//  Created by KevinKong on 14-8-26.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MobClick.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import <OpenUDID/OpenUDID.h>
 
#define LMH_Debug 1  // 1- Debug 模式. 0-Release 模式.


#if LMH_Debug
#define LMHLog(fmt, ...) NSLog((@"%s [Line %zi] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LMHLog(fmt, ...)
#endif

//
static const CGFloat kNavigationBarHeight = 44.0f;
static const CGFloat kTabBarHeight = 35.0f;

/**
 个推的相关账号.
 */
#define GeXinAPNS_AppleID @"d0mIDMriHX94VM418faNH4"
#define GeXinAPNS_AppKey @"gsX0a4WKv88b1EAp3iyyW1"
#define GeXinAPNS_AppSecret @"xiHPEeLCOX5IIOmE0Ncg56"
#define GeXinAPNS_MasterSecret @"UuvMCwHHqiAfFaimRdCov1"

/*
 全局 frame 相关
 */
#define ScreenW   [UIScreen mainScreen].bounds.size.width
#define ScreenH   [UIScreen mainScreen].bounds.size.height
#define UITabBarHeight 44
/*
 */
#define UIColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CurrentOSVersion  [[UIDevice currentDevice].systemVersion doubleValue]

//设备
#define STATUSBAR_HEIGHT            [[UIApplication sharedApplication] statusBarFrame].size.height
#define FULL_WIDTH                  [[UIScreen mainScreen] bounds].size.width
#define FULL_HEIGHT                 (ScreenH - ((floor(NSFoundationVersionNumber) >= 7) ? 0 : STATUSBAR_HEIGHT))
#define IS_IPHONE5                  (SCREEN_HEIGHT == 568)

//颜色
#define RGBA(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r,g,b)        RGBA(r,g,b,1)
#define GRAY_LINE_COLOR   [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]
#define BLACK_COLOR       RGB(51,51,51)
#define DARKGRAY_COLOR    RGB(123,123,123)
#define GRAY_COLOR        RGB(104,104,104)
#define GRAY_CELL_COLOR   [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]
#define RED_COLOR         [UIColor colorWithRed:1 green:0.39 blue:0.49 alpha:1]
#define TABLE_COLOR       [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
#define TEXTV_COLOR       [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]
#define DETAIL_COLOR      [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]
#define ALL_COLOR         RGB(241, 71, 134)

#define LMH_COLOR_BLACK         RGB(51, 51, 51)
#define LMH_COLOR_GRAY          RGB(102, 102, 102)
#define LMH_COLOR_LIGHTGRAY     RGB(153, 153, 153)
#define LMH_COLOR_SKIN          RGB(255, 74, 155)
#define LMH_COLOR_ORANGE        RGB(252,105,58)
#define LMH_COLOR_LINE          RGB(224,224,224)
#define LMH_COLOR_LIGHTLINE     RGB(240,240,240)
#define LMH_COLOR_CELL          RGB(250,250,250)
#define LMH_COLOR_BACK          RGB(242,242,242)
#define LMH_COLOR_LIGHTbLUE     RGB(54, 130, 183)

//字体
#define FONT(s)          [UIFont systemFontOfSize:s]

#define LMH_FONT_18          [UIFont systemFontOfSize:18]
#define LMH_FONT_17          [UIFont systemFontOfSize:17]
#define LMH_FONT_16          [UIFont systemFontOfSize:16]
#define LMH_FONT_15          [UIFont systemFontOfSize:15]
#define LMH_FONT_14          [UIFont systemFontOfSize:14]
#define LMH_FONT_13          [UIFont systemFontOfSize:13]
#define LMH_FONT_12          [UIFont systemFontOfSize:12]
#define LMH_FONT_11          [UIFont systemFontOfSize:11]
#define LMH_FONT_10          [UIFont systemFontOfSize:10]
#define LMH_FONT_9           [UIFont systemFontOfSize:9]

//按比例计算尺寸 设计稿是以720为基准
#define RATIO(size)      size*ScreenW/720

//图片加载
#define LOCAL_IMG(img)   [UIImage imageNamed:img]

#import <QuartzCore/QuartzCore.h>

/*
 定义一些修改逻辑宏.
    定义这些宏是为了在两个版本迭代之间,做一些改动.将代码丢失率降到最低.
 */
#define LMH_Main_Page_Update_logic 1 // 1-修改首页的架构,以TabBarController样式.  0.没有TabBarController 的样式.

CG_INLINE BOOL stringIsEmpty(NSString *string) {
    if([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] == 0) {
        return YES;
    }
    return NO;
}


