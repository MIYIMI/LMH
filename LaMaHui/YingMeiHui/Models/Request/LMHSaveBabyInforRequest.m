//
//  LMHSaveBabyInforRequest.m
//  YingMeiHui
//
//  Created by Zhumingming on 14-12-1.
//  Copyright (c) 2014年 xieyanke. All rights reserved.
//

#import "LMHSaveBabyInforRequest.h"

@implementation LMHSaveBabyInforRequest

- (id)initWithUserID:(long)userid
        andUserToken:(NSString *)token
        andbaby_name:(NSString *)baby_name
         andbaby_sex:(NSString *)baby_sex
 andbaby_birthday_at:(NSString *)baby_birthday_at
       andmother_birthday_at:(NSString *)mother_birthday_at
          andaddress:(NSString *)address
{
    if (self = [super init]) {
        NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:7];
        if (userid != -1) {
            [subParams setObject:[NSNumber numberWithLong:userid] forKey:@"user_id"];
        }
        
        if (token) {
            [subParams setObject:token forKey:@"user_token"];
        }
        
        
        if (baby_name) {
            [subParams setObject:baby_name forKey:@"baby_name"];
        }
        if (baby_sex) {
            [subParams setObject:baby_sex forKey:@"baby_sex"];
        }
        if (baby_birthday_at) {
            [subParams setObject:baby_birthday_at forKey:@"baby_birthday_at"];
        }
        if (mother_birthday_at) {
            [subParams setObject:mother_birthday_at forKey:@"mother_birthday_at"];
        }
        if (address) {
            [subParams setObject:address forKey:@"address"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:subParams forKey:@"params"];
    }
    
    return self;
}

- (NSString *)method
{
    return @"baby_info_ins";
}

@end
