//
//  UIDevice+Resolutions.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-24.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceModel:NSObject

+ (id)shareModel;
@property(nonatomic,strong) NSString *phoneType;
@property(nonatomic,strong) NSString *netType;
@property(nonatomic,strong) NSString *deviceType;
@property(nonatomic,strong) NSString *systemOS;
@property(nonatomic,strong) NSString *carrierName;
@property(nonatomic,strong) NSString *scrResolution;

@end
