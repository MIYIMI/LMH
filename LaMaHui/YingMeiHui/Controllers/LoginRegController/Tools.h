//
//  Tools.h
//  HanYuanCXSHS
//
//  Created by machair on 13-12-5.
//  Copyright (c) 2013年 machair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (BOOL)checkPassword:(NSString *)a isEqual:(NSString *)b;
//字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
//文字正则
+(BOOL)isValidateUserName:(NSString *)userName;
+(BOOL)isValidatePassword:(NSString *)pass;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidateTelephone:(NSString *)telephone;
//验证数字年龄
+(BOOL)isValidateAge:(NSString *)age;
//计算经纬度 距离
+(double)lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
//计算日期时间差
+ (NSInteger)compareDate:(NSString *)oneDate andAnother:(NSString *)twoDate;
//去掉显示秒
+ (NSString *)subStringFromCreateDate:(NSString *)creatDate;
@end
