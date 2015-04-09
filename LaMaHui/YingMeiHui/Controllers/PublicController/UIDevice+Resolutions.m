//
//  UIDevice+Resolutions.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "UIDevice+Resolutions.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreLocation/CoreLocation.h>

/*
 @"i386"      on the simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPod5,1"   on iPod Touch Fifth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on 3rd Generation iPad
 @"iPad3,2":  on iPad 3(GSM+CDMA)
 @"iPad3,3":  on iPad 3(GSM)
 @"iPad3,4":  on iPad 4(WiFi)
 @"iPad3,5":  on iPad 4(GSM)
 @"iPad3,6":  on iPad 4(GSM+CDMA)
 @"iPhone3,1" on iPhone 4
 @"iPhone4,1" on iPhone 4S
 @"iPhone5,1" on iPhone 5
 @"iPad3,4"   on 4th Generation iPad
 @"iPad2,5"   on iPad Mini
 @"iPhone5,1" on iPhone 5(GSM)
 @"iPhone5,2" on iPhone 5(GSM+CDMA)
 @"iPhone5,3  on iPhone 5c(GSM)
 @"iPhone5,4" on iPhone 5c(GSM+CDMA)
 @"iPhone6,1" on iPhone 5s(GSM)
 @"iPhone6,2" on iPhone 5s(GSM+CDMA)
 @"iPhone7,1" on iPhone 6+
 @"iPhone7,2" on iPhone 6
 */

@interface DeviceModel()<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager* locationmanager;
@property(nonatomic,retain) CTTelephonyNetworkInfo *networkInfo;


@end

@implementation DeviceModel

static DeviceModel *devModel = nil;
+ (id)shareModel{
    @synchronized (self)
    {
        if (devModel == nil)
        {
            devModel = [[self alloc] init];
        }
        [devModel currentModel];
    }
    return devModel;
}

- (void)currentModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //获取设备
    if([platform hasPrefix:@"iPhone"]){
        self.deviceType = @"iPhone";
    }else if([platform hasPrefix:@"iPod"]){
        self.deviceType = @"iPod";
    }else if([platform hasPrefix:@"iPad"]){
        self.deviceType = @"iPad";
    }else{
        self.deviceType = @"Simulator";
    }
    
    //获取系统版本号
    self.systemOS = [[UIDevice currentDevice] systemVersion];
    
    //获取sim卡信息
    self.carrierName = @"NONE";
    if (!_networkInfo) {
        _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    CTCarrier *carrier = _networkInfo.subscriberCellularProvider;
    if (carrier.carrierName) {
        self.carrierName = carrier.carrierName;
    }
    
    //获取机型
    if ([platform isEqualToString:@"iPhone1,1"]) self.phoneType =  @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) self.phoneType =  @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) self.phoneType =  @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) self.phoneType =  @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) self.phoneType =  @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) self.phoneType =  @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) self.phoneType =  @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) self.phoneType =  @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) self.phoneType =  @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) self.phoneType =  @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) self.phoneType =  @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) self.phoneType =  @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) self.phoneType =  @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) self.phoneType =  @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) self.phoneType =  @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   self.phoneType =  @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   self.phoneType =  @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   self.phoneType =  @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   self.phoneType =  @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   self.phoneType =  @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   self.phoneType =  @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   self.phoneType =  @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   self.phoneType =  @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   self.phoneType =  @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   self.phoneType =  @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   self.phoneType =  @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   self.phoneType =  @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   self.phoneType =  @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   self.phoneType =  @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   self.phoneType =  @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   self.phoneType =  @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   self.phoneType =  @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   self.phoneType =  @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   self.phoneType =  @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   self.phoneType =  @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   self.phoneType =  @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   self.phoneType =  @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   self.phoneType =  @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   self.phoneType =  @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   self.phoneType =  @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      self.phoneType =  @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    self.phoneType =  @"iPhone Simulator";
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            self.netType = @"NONE";
            break;
        case 1:
            self.netType = @"2G";
            break;
        case 2:
            self.netType = @"3G";
            break;
            
        case 3:
            self.netType = @"4G";
            break;
            
        case 4:
            self.netType = @"LTE";
            break;
            
        case 5:
            self.netType = @"WIFI";
            break;
            
        default:
            self.netType = @"NONE";
            break;
    }
}

- (void)locationJW{
    //获取地理坐标
    if (!_locationmanager) {
        _locationmanager = [[CLLocationManager alloc]init];
    }
    
    if([_locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationmanager requestAlwaysAuthorization]; // 永久授权
        [_locationmanager requestWhenInUseAuthorization]; //使用中授权
    }

    //设置定位的精度
    _locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationmanager.distanceFilter = kCLDistanceFilterNone;
    
    //实现协议
    _locationmanager.delegate = self;
    //开始定位
    [_locationmanager startUpdatingLocation];
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    NSLog(@"输出当前的精度和纬度");
    NSLog(@"精度：%f 纬度：%f",coordinate.latitude,coordinate.longitude);
    //停止定位
    [_locationmanager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationmanager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /***********************************************************/
    
    // 用户未开启或不允许定位
    if ([error code] == kCLErrorDenied)
    {
        [[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"定位未打开,请打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
    // 停止定位
    [_locationmanager stopUpdatingLocation];
}
@end
