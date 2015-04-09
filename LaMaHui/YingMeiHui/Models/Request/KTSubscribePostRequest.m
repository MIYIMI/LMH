//
//  KTSubscribePostRequest.m
//  YingMeiHui
//
//  Created by 林程宇 on 14-4-2.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTSubscribePostRequest.h"
#import "kata_UserManager.h"

@implementation KTSubscribePostRequest

- (id)initWithBrandID:(NSInteger)brandid
              andType:(NSString *)type
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:2];
        if (brandid != -1) {
            [subParams setObject:[NSNumber numberWithInteger:brandid] forKey:@"brand_id"];
        }
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
            [subParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"device_token"];
        } else {
            [subParams setObject:@"" forKey:@"device_token"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] isKindOfClass:[NSNumber class]]) {
            
            NSInteger userid = [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"user_id"] intValue];
            [subParams setObject:[NSNumber numberWithInteger:userid] forKey:@"user_id"];
        }
        
        if ([[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"token"] && [[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"token"] isKindOfClass:[NSString class]]) {
            
            NSString *token = (NSString *)[[[kata_UserManager sharedUserManager] userInfo] objectForKey:@"token"];
            [subParams setObject:token forKey:@"device_token"];
        }
        
        if (type) {
            [subParams setObject:type forKey:@"type"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"subscribe_post";
}

@end
