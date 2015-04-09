//
//  LMHChangeUserIconRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-22.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHChangeUserIconRequest.h"

@implementation LMHChangeUserIconRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        user_image:(NSString *)user_image
         user_name:(NSString *)user_name
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:4];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        
        if (user_image) {
            [subParams setObject:user_image forKey:@"user_image"];
        }
        if (user_name) {
            [subParams setObject:user_name forKey:@"user_name"];
        }
        
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"uploads_img_and_name";
}

@end
