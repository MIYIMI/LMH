//
//  TrackInfoModel.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-11-6.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "TrackInfoModel.h"

@implementation TrackInfoModel

//没有定义的key
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"没有定义的key -- %@",key);
}
@end
