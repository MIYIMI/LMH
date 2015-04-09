//
//  NSString+KTStringHelper.m
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "NSString+KTStringHelper.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (KTStringHelper)

- (NSString *)md5
{
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, strlen(src), result);
    NSString *ret = [[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return [ret lowercaseString];
}

- (NSString *)toGBK
{
    NSStringEncoding enc = CFStringConvertNSStringEncodingToEncoding(kCFStringEncodingGB_18030_2000);
    NSString *ret = [[NSString alloc] initWithFormat:@"%@", [self stringByAddingPercentEscapesUsingEncoding:enc]];
    return ret;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)urlEncode
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

@end
