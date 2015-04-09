//
//  kata_GlobalConst.h
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-6.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kata_GlobalConst : NSObject

extern NSString *const UMENG_APPKEY;
extern NSString *const WEIXIN_APPID;
extern NSString *const WEBSITE_URL;
extern NSString *const WEIXIN_APPKEY;
extern NSString *const WEIXINPAY_APPID;
extern NSString *const QQ_APPID;
extern NSString *const QQ_APPKEY;
extern NSString *const SINA_APPID;
extern NSString *const APPURL;
extern NSString *const SINA_INFOURL;
extern NSString *const WEIXIN_INFOURL;
extern NSString *const WXSECRET;


// 根据 value 值返回订单/商品  的状态
+(NSString *)getOrderStatesWithIntValue:(NSInteger)value;
@end
