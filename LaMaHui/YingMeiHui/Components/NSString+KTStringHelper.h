//
//  NSString+KTStringHelper.h
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KTStringHelper)

- (NSString *)md5;
- (NSString *)toGBK;
- (NSString *)trim;
- (NSString *)urlEncode;

@end
