//
//  KATACheckUtils.h
//  SanDing
//
//  Created by 林 程宇 on 13-5-2.
//  Copyright (c) 2013年 Codeoem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KATACheckUtils : NSObject

// 检查网络环境
+ (BOOL)isEnableWIFI;
+ (BOOL)isEnable3G;
+ (BOOL)isLink;

// 检查屏幕类型
+ (BOOL)isRetina;

//检查系统版本
+ (BOOL)isOS4;

@end
