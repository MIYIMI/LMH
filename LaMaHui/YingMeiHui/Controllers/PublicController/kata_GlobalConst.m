//
//  kata_GlobalConst.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-6.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "kata_GlobalConst.h"

@implementation kata_GlobalConst

NSString *const UMENG_APPKEY            =   @"5357c70c56240bb08f020f47";                // 友盟AppKey
NSString *const WEIXIN_APPID            =   @"wxa2dea52a069e6592";                      // 微信AppID
NSString *const WEIXINPAY_APPID         =   @"wxbd46e576b4bf998d";                      // 微信PAYAppID
NSString *const WEIXIN_APPKEY           =   @"bP3ykQHi8OInoysbAzat29AfEDq2tq54YwovFOsdOVS4gj7ewshZphfWDDjej3RxjQcfg7FUpNJljqrJ9kGVr1dDc5l3S5PX0aK99laXslLjID4nFOXRYFaeG8g9x1fq";
NSString *const WXSECRET             =   @"bf89daf7a823d7372c993b82aae6076b";            //微信密匙

NSString *const WEBSITE_URL             =   @"http://www.lamahui.com/";           // 首页地址
NSString *const QQ_APPID                =   @"101070067";                           //qq appid 100424468
NSString *const QQ_APPKEY                =   @"f44002ec8859b64f44091528d28aad6e";    //qq appkey

NSString *const SINA_APPID              =   @"1314543546";                        //新浪appid
NSString *const APPURL                  =   @"http://www.lamahui.com";
NSString *const SINA_INFOURL            =   @"https://api.weibo.com/2/users/show.json";  //新浪微博个人信息获取url

// 根据 value 值返回订单/商品  的状态
+(NSString *)getOrderStatesWithIntValue:(NSInteger)value{
    /*订单状态  0：未付款   1：未发货   2：发货中  3：已发货  4：订单取消  5：退货中   6：订单已完成
     7:换货中  8：已付款 9：退款中 10:订单失败 11:已退款*/
    
    switch (value) {
        case 0:
            return @"未付款";
            break;
        case 1:
            return @"未发货";
            break;
        case 2:
            return @"发货中";
            break;
        case 3:
            return @"已发货";
            break;
        case 4:
            return @"订单取消";
            break;
        case 5:
            return @"退货中";
            break;
        case 6:
            return @"订单已完成";
            break;
        case 7:
            return @"换货中";
            break;
        case 8:
            return @"已付款";
            break;
        case 9:
            return @"退款中";
            break;
        case 10:
            return @"订单失败";
            break;
        case 11:
            return @"已退款";
        default:
            break;

    }
    return nil;
}
@end
