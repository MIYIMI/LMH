//
//  Tools.m
//  HanYuanCXSHS
//
//  Created by machair on 13-12-5.
//  Copyright (c) 2013年 machair. All rights reserved.
//

#import "Tools.h"
#import <CoreLocation/CoreLocation.h>
@implementation Tools


+ (BOOL)checkPassword:(NSString *)a isEqual:(NSString *)b
{
    if([a isEqualToString:b])
    {
        return YES;
    }else
    {
        return false;
    }
}

//计算日期时间差
+ (NSInteger)compareDate:(NSString *)oneDate andAnother:(NSString *)twoDate
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //创建了两个日期对象
    NSDate *date1 = [dateFormatter dateFromString:oneDate];
    NSDate *date2 = [dateFormatter dateFromString:twoDate];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    //天
    NSInteger days=(time)/(3600*24);
    //小时
    //NSInteger hours=(time)%(3600*24)/3600;
    
    return days;
}
//计算经纬度距离 单位KM
#define PI 3.1415926
//+(double)lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
//    double er = 6378137; // 6378700.0f;
//    
//    double radlat1 = PI*lat1/180.0f;
//    double radlat2 = PI*lat2/180.0f;
//    
//    double radlong1 = PI*lon1/180.0f;
//    double radlong2 = PI*lon2/180.0f;
//    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
//    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
//    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
//    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
//    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
//    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
//    double x1 = er * cos(radlong1) * sin(radlat1);
//    double y1 = er * sin(radlong1) * sin(radlat1);
//    double z1 = er * cos(radlat1);
//    double x2 = er * cos(radlong2) * sin(radlat2);
//    double y2 = er * sin(radlong2) * sin(radlat2);
//    double z2 = er * cos(radlat2);
//    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
//    double theta = acos((er*er+er*er-d*d)/(2*er*er));
//    double dist  = theta*er;
//    return dist;
//}

+ (double)lantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    
    return distance;
}

#pragma mark -
#pragma mark - 字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([string isEqualToString:@"(null)"]) {
        
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark -
#pragma mark - 文字正则

+(BOOL)isValidateUserName:(NSString *)userName
{
    NSString *userNameRegex = @"^[0-9a-zA-Z_]{4,16}$";
    
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    
    return [userNameTest evaluateWithObject:userName];
}

+(BOOL)isValidatePassword:(NSString *)pass
{
    NSString *passRegex = @"^[0-9a-zA-Z_@#$%&*]{4,16}$";
    
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    
    return [passTest evaluateWithObject:pass];
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidateTelephone:(NSString *)telephone
{
    NSString *telephoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneRegex];
    
    return [telephoneTest evaluateWithObject:telephone];
}

-(BOOL) isTelephone
{
    NSString *regex = @"^（(13)|(14)|(15)|(17)|(18))\\d{9}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

+(BOOL)isValidateAge:(NSString *)age
{
    NSString *ageRegex = @"^[0-9]{1,3}$";
    
    NSPredicate *ageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ageRegex];
    
    return [ageTest evaluateWithObject:age];
}


+(void) tel:(NSString *)phone
{
    if (phone != nil) {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phone];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}
+ (NSString *)subStringFromCreateDate:(NSString *)creatDate
{
    NSArray *dataArr = [creatDate componentsSeparatedByString:@":"];
//    NSString *string = nil;
//    for (NSInteger i = 0; i < dataArr.count; i++) {
//        if (i == 0) {
//            string = [NSString stringWithFormat:dataArr[0]];
//        }
//    }
    NSString *str = [NSString stringWithFormat:@"%@:%@",[dataArr objectAtIndex:0], [dataArr objectAtIndex:1]];
    return str;
}
@end
